Return-path: <linux-media-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:43804 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760056AbZJMOob (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 10:44:31 -0400
Subject: Re: [LTP] [PATCH] pac_common: redesign function for finding
	Start	Of Frame
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Kyle Guinn <elyk03@gmail.com>,
	Theodore Kilgore <kilgota@auburn.edu>,
	ltp-list@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	V4L Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4AC90C17.70103@freemail.hu>
References: <4AC90BBF.9040803@freemail.hu>  <4AC90C17.70103@freemail.hu>
Content-Type: text/plain; charset=utf-8
Date: Tue, 13 Oct 2009 20:13:34 +0530
Message-Id: <1255445014.8438.65.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-10-04 at 22:56 +0200, Németh Márton wrote: 
> Hi,
> 
> I wrote a simple test for pac_find_sof(). I implemented a user-space test
> which takes the implementation from the source file and calls it directly.
> You can find the source code of the test attached.

Németh,

Can you please add this test to LTP then ?

Regards--
Subrata

> 
> The test results for the pac_find_sof() implementation in the Linux kernel
> 2.6.32-rc1 is the following:
> 
> Test case 1: exact match
> PDEBUG: SOF found, bytes to analyze: 5. Frame starts at byte #5
> PASSED
> 
> Test case 2: offset 1
> PDEBUG: SOF found, bytes to analyze: 6. Frame starts at byte #6
> PASSED
> 
> Test case 3: offset 1, first byte may be misleading
> FAILED
> 
> Test case 4: offset 2, first two bytes may be misleading
> PDEBUG: SOF found, bytes to analyze: 7. Frame starts at byte #7
> PASSED
> 
> Test case 5: offset 3, first three bytes may be misleading
> FAILED
> 
> Test case 6: offset 4, first four bytes may be misleading
> FAILED
> 
> Test case 7: pattern starts at end of packet and continues in the next one
> PDEBUG: SOF found, bytes to analyze: 1. Frame starts at byte #1
> PASSED
> 
> Test case 8: splited pattern, with misleading first byte
> FAILED
> 
> Test case 9: splited pattern, with misleading first three bytes
> FAILED
> 
> Test case 10: no match, extra byte at offset 1
> PASSED
> 
> Test case 11: no match, extra byte at offset 2
> PASSED
> 
> Test case 12: no match, extra byte at offset 3
> PASSED
> 
> Test case 13: no match, extra byte at offset 4
> PASSED
> 
> I also executed the test with the patched pac_find_sof() implementation
> and that one passes all these test cases.
> 
> Regards,
> 
> 	Márton Németh
> 
> Németh Márton wrote:
> > From: Márton Németh <nm127@freemail.hu>
> > 
> > The original implementation of pac_find_sof() does not always find
> > the Start Of Frame (SOF) marker. Replace it with a state machine
> > based design.
> > 
> > The change was tested with Labtec Webcam 2200.
> > 
> > Signed-off-by: Márton Németh <nm127@freemail.hu>
> > ---
> > --- linux-2.6.32-rc1.orig/drivers/media/video/gspca/pac_common.h	2009-09-10 00:13:59.000000000 +0200
> > +++ linux-2.6.32-rc1/drivers/media/video/gspca/pac_common.h	2009-10-04 21:49:19.000000000 +0200
> > @@ -33,6 +33,45 @@
> >  static const unsigned char pac_sof_marker[5] =
> >  		{ 0xff, 0xff, 0x00, 0xff, 0x96 };
> > 
> > +/*
> > +   The following state machine finds the SOF marker sequence
> > +   0xff, 0xff, 0x00, 0xff, 0x96 in a byte stream.
> > +
> > +	   +----------+
> > +	   | 0: START |<---------------\
> > +	   +----------+<-\             |
> > +	     |       \---/otherwise    |
> > +	     v 0xff                    |
> > +	   +----------+ otherwise      |
> > +	   |     1    |--------------->*
> > +	   |          |                ^
> > +	   +----------+                |
> > +	     |                         |
> > +	     v 0xff                    |
> > +	   +----------+<-\0xff         |
> > +	/->|          |--/             |
> > +	|  |     2    |--------------->*
> > +	|  |          | otherwise      ^
> > +	|  +----------+                |
> > +	|    |                         |
> > +	|    v 0x00                    |
> > +	|  +----------+                |
> > +	|  |     3    |                |
> > +	|  |          |--------------->*
> > +	|  +----------+ otherwise      ^
> > +	|    |                         |
> > +   0xff |    v 0xff                    |
> > +	|  +----------+                |
> > +	\--|     4    |                |
> > +	   |          |----------------/
> > +	   +----------+ otherwise
> > +	     |
> > +	     v 0x96
> > +	   +----------+
> > +	   |  FOUND   |
> > +	   +----------+
> > +*/
> > +
> >  static unsigned char *pac_find_sof(struct gspca_dev *gspca_dev,
> >  					unsigned char *m, int len)
> >  {
> > @@ -41,17 +80,54 @@ static unsigned char *pac_find_sof(struc
> > 
> >  	/* Search for the SOF marker (fixed part) in the header */
> >  	for (i = 0; i < len; i++) {
> > -		if (m[i] == pac_sof_marker[sd->sof_read]) {
> > -			sd->sof_read++;
> > -			if (sd->sof_read == sizeof(pac_sof_marker)) {
> > +		switch (sd->sof_read) {
> > +		case 0:
> > +			if (m[i] == 0xff)
> > +				sd->sof_read = 1;
> > +			break;
> > +		case 1:
> > +			if (m[i] == 0xff)
> > +				sd->sof_read = 2;
> > +			else
> > +				sd->sof_read = 0;
> > +			break;
> > +		case 2:
> > +			switch (m[i]) {
> > +			case 0x00:
> > +				sd->sof_read = 3;
> > +				break;
> > +			case 0xff:
> > +				/* stay in this state */
> > +				break;
> > +			default:
> > +				sd->sof_read = 0;
> > +			}
> > +			break;
> > +		case 3:
> > +			if (m[i] == 0xff)
> > +				sd->sof_read = 4;
> > +			else
> > +				sd->sof_read = 0;
> > +			break;
> > +		case 4:
> > +			switch (m[i]) {
> > +			case 0x96:
> > +				/* Pattern found */
> >  				PDEBUG(D_FRAM,
> >  					"SOF found, bytes to analyze: %u."
> >  					" Frame starts at byte #%u",
> >  					len, i + 1);
> >  				sd->sof_read = 0;
> >  				return m + i + 1;
> > +				break;
> > +			case 0xff:
> > +				sd->sof_read = 2;
> > +				break;
> > +			default:
> > +				sd->sof_read = 0;
> >  			}
> > -		} else {
> > +			break;
> > +		default:
> >  			sd->sof_read = 0;
> >  		}
> >  	}
> > 
> 
> ------------------------------------------------------------------------------
> Come build with us! The BlackBerry&reg; Developer Conference in SF, CA
> is the only developer event you need to attend this year. Jumpstart your
> developing skills, take BlackBerry mobile applications to market and stay 
> ahead of the curve. Join us from November 9&#45;12, 2009. Register now&#33;
> http://p.sf.net/sfu/devconf
> _______________________________________________ Ltp-list mailing list Ltp-list@lists.sourceforge.net https://lists.sourceforge.net/lists/listinfo/ltp-list

