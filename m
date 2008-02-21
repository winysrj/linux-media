Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1LCmcR0032407
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 07:48:38 -0500
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.231])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1LCm73W015386
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 07:48:07 -0500
Received: by wx-out-0506.google.com with SMTP id t16so24135wxc.6
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 04:48:02 -0800 (PST)
Message-ID: <175f5a0f0802210448m70d6a1d6s1c627a54f30b54a1@mail.gmail.com>
Date: Thu, 21 Feb 2008 13:48:00 +0100
From: "H. Willstrand" <h.willstrand@gmail.com>
To: "Thomas Kaiser" <linux-dvb@kaiser-linux.li>,
	"H. Willstrand" <h.willstrand@gmail.com>,
	"Linux and Kernel Video" <video4linux-list@redhat.com>
In-Reply-To: <20080221124305.GA714@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <175f5a0f0802201254q7dc96190k35caafe9ba7d3274@mail.gmail.com>
	<20080220215850.GA2391@daniel.bse> <47BCA5BA.20009@kaiser-linux.li>
	<175f5a0f0802201441n5ea7bb58rdfa70663799edcad@mail.gmail.com>
	<47BCB5DB.8000800@kaiser-linux.li>
	<175f5a0f0802201602i52187c1fxb2e980c7e86fcca6@mail.gmail.com>
	<20080221012048.GA2924@daniel.bse>
	<175f5a0f0802210110k11dc73f6pbbdd7100c1ca8fdb@mail.gmail.com>
	<47BD67C8.5000305@kaiser-linux.li> <20080221124305.GA714@daniel.bse>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: V4L2_PIX_FMT_RAW
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, Feb 21, 2008 at 1:43 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> On Thu, Feb 21, 2008 at 01:00:08PM +0100, Thomas Kaiser wrote:
>  > H. Willstrand wrote:
>
> > >Still, I'm suspectious about the definition "raw" used here.
>  > >RAW should mean unprocessed image data:
>  > >* no white balance adjustment
>  > >* no color saturation adjustments
>  > >* no contrast adjustments
>  > >* no sharpness improvements
>  > >* no compression with loss
>  >
>  > Yes, raw means "as it is" no stripping, decoding  or removing of SOF
>  > headers are done in the driver. May be V4L2_PIX_FMT_AII (AII -> As It Is)
>  > is the better name?
>
>  IMHO "raw" is the output of the ADC(s).
>
>  Uncompressed.
>
>  For webcams probably something like V4L2_PIX_FMT_SBGGR16.
>
>  Lossless transformations allowed.

Almost agree, meaning lossless transformation can be a compression :)

Cheers,
Harri

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
