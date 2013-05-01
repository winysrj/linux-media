Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:38807 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753490Ab3EARIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 May 2013 13:08:51 -0400
Date: Wed, 1 May 2013 19:11:53 +0200
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Timo Teras <timo.teras@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130501171153.GA1377@dell.arpanet.local>
References: <20130325143647.3da1360f@redhat.com>
 <20130325194820.7c122834@vostro>
 <20130325153220.3e6dbfe5@redhat.com>
 <20130325211238.7c325d5e@vostro>
 <20130326102056.63b55916@vostro>
 <20130327161049.683483f8@vostro>
 <20130328105201.7bcc7388@vostro>
 <20130328094052.26b7f3f5@redhat.com>
 <20130328153556.0b58d1aa@vostro>
 <20130328165459.6231a5b1@vostro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328165459.6231a5b1@vostro>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 28, 2013 at 04:54:59PM +0200, Timo Teras wrote:
> On Thu, 28 Mar 2013 15:35:56 +0200
> Timo Teras <timo.teras@iki.fi> wrote:
> 
> > On Thu, 28 Mar 2013 09:40:52 -0300
> > Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > 
> > > Em Thu, 28 Mar 2013 10:52:01 +0200
> > > Timo Teras <timo.teras@iki.fi> escreveu:
> > > 
> > > > On Wed, 27 Mar 2013 16:10:49 +0200
> > > > Timo Teras <timo.teras@iki.fi> wrote:
> > > > 
> > > > > On Tue, 26 Mar 2013 10:20:56 +0200
> > > > > Timo Teras <timo.teras@iki.fi> wrote:
> > > > > 
> > > > > > I did manage to get decent traces with USBlyzer evaluation
> > > > > > version.
> > > > > 
> > > > > Nothing _that_ exciting there. Though, there's quite a bit of
> > > > > differences on certain register writes. I tried copying the
> > > > > changed parts, but did not really help.
> > > > > 
> > > > > Turning on saa7115 debug gave:
> > > > > 
> > > > > saa7115 1-0025: chip found @ 0x4a (ID 000000000000000) does not
> > > > > match a known saa711x chip.
> > > > 
> > > > Well, I just made saa7115.c ignore this ID check, and defeault to
> > > > saa7113 which is apparently the chip used.
> > > > 
> > > > And now it looks like things start to work a lot better.
> > > > 
> > > > Weird that the saa7113 chip is missing the ID string. Will
> > > > continue testing.
> > > 
> > > That could happen if saa7113 is behind some I2C bridge and when
> > > saa7113 is not found when the detection code is called.
> > 
> > Smells to me that they replaced the saa7113 with cheaper clone that
> > does not support the ID string.
> > 
> > Sounds like the same issue as:
> > http://www.spinics.net/lists/linux-media/msg57926.html
> > 
> > Additionally noted that something is not initialized right:
> > 
> > With PAL signal:
> > - there's some junk pixel in beginning of each line (looks like pixes
> >   from previous lines end), sync issue?
> > - some junk lines at the end
> > - distorted colors when white and black change between pixels
> 
> Still have not figured out this one. Could be probably related to the
> saa7113 differences.
> 
> > With NTSC signal:
> > - unable to get a lock, and the whole picture looks garbled
> 
> NTSC started working after I removed all the saa711x writes to
> following registers:
>  R_14_ANAL_ADC_COMPAT_CNTL
>  R_15_VGATE_START_FID_CHG
>  R_16_VGATE_STOP
>  R_17_MISC_VGATE_CONF_AND_MSB
> 

This is the exact same behavior as i see on the gm7113c chip
in the stk1160, and the smi2021 devices.

See here:
http://www.spinics.net/lists/linux-media/msg63163.html

> - Timo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
