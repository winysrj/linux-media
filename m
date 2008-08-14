Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7EIpeqj017723
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 14:51:40 -0400
Received: from smtp0.lie-comtel.li (smtp0.lie-comtel.li [217.173.238.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7EIpTEk018013
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 14:51:29 -0400
Message-ID: <48A47EC4.5070405@kaiser-linux.li>
Date: Thu, 14 Aug 2008 20:51:48 +0200
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <1218734045.1696.39.camel@localhost>
In-Reply-To: <1218734045.1696.39.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: v4l library - decoding of Pixart JPEG frames
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

Hello Jean-Francois, Hans

I am the original developer who started the PAC7311 support for gspca V1.

Jean-Francois Moine wrote:
> Hello Hans,
> 
> I found that the webcams containing a Pixart JPEG chip (PAC 73xx)
> generate strange JPEG frames: they contains 'ff ff ff xx' markers every
> 1024 or 512 bytes
xx = 01 -> 1024 Bytes
xx = 02 -> 512 Bytes
xx = 00 -> size of the following block is not defined

I don't know for what this markers should be good for.
So, I suggest to just remove them in the driver.


> and there are eight unused bits at the end of each
> JPEG block

End or Start? Depends where the end of the frame marker is defined! The 
Last Byte in the frame marker has the same bit pattern which you will 
find after each MCU. I call it MCU markers.
So, throw the first MCU marker (last Byte in the frame header) away in 
the driver. While decoding the JPEG in the V4L library one have to throw 
away 8 Bit after each MCU.

 > (I saw also a 90 degrees rotation with the PAC 7302).
Same thing I saw by analyzing usbsnoops from a PAC7302.

> 
> So, I added a new pixel format V4L2_PIX_FMT_PJPG for this encoding. It
> is generated by the pac7311 subdriver of gspca. May you add the code for
> decoding this format in the V4L library?

You should call it _SPJPG -> Special Pixart JPEG, just kidding :-)

> 
> I could have done a patch by myself, but the tiny jpeg decoder is rather
> complex, and I could not find the right place to do the job.

Hans: Do you use tiny jpeg decoder in the v4l library?
I should have a version of tiny jpeg somewhere, where this special 
Pixart jpeg decoding is already implemented. But anyway it's simple, 
just skip 8 Bits after each MCU.


> If it may
> help, I wrote a simple image viewer (http://moinejf.free.fr/siv.c) which
> takes a raw webcam image and displays it via gtk+. It contains the
> Pixart JPEG decoder and the two differences from normal JPEG are
> identified by 'pac7311'.

I really don't understand why Pixart added this stuff. Once I asked 
about more information about the stream, they just told me that they had 
develop their own JPEG coding and decoding and it is company confidential.

Hope this information helps.

Thomas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
