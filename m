Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4GEZKfb007407
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 10:35:20 -0400
Received: from acheron.ifi.lmu.de (acheron.ifi.lmu.de [129.187.214.135])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4GEZ5dp019077
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 10:35:06 -0400
Received: from fluff.wintermute.medea (fluff.medien.ifi.lmu.de [141.84.8.80])
	by acheron.ifi.lmu.de (Postfix) with ESMTP id BC74B44E9C
	for <video4linux-list@redhat.com>;
	Fri, 16 May 2008 16:34:55 +0200 (CEST)
Date: Fri, 16 May 2008 16:35:37 +0200
From: Richard Atterer <richard@2008.atterer.net>
To: video4linux-list@redhat.com
Message-ID: <20080516143537.GA7963@fluff.lan>
References: <a5eaedfa0805160656t29d2858ao3c1c81469b87b0af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5eaedfa0805160656t29d2858ao3c1c81469b87b0af@mail.gmail.com>
Subject: Re: pixel count doubts
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

On Fri, May 16, 2008 at 07:26:27PM +0530, Veda N wrote:
> Hi,
> I am trying to write a camera sensor driver.
> 
> The sensor documents says that -
> For the resolution VGA, The pixel count is 640x480x3.
> 
> I did not understand what is meant by x3 in pixel count.
> 
> Usually it is 60x480. The number of bytes per pixel is 2.
> 
> Does this mean that instead of 2 bytes per pixel. it is 3 bytes?

There isn't really enough information to tell, but probably yes.

Note that it is often the case that a claimed sensor resolution of, say, 
640x480 means that the _Bayer pattern_ resolution is 640x480 - in other 
words, there are that many pixels, but each pixel is only for one of the 
colours red, green or blue, and further interpolation is necessary to get a 
640x480 RGB picture.

So the "640x480x3" /could/ mean "3 subpixels for each image pixel", but I 
strongly doubt it; Foveon sensors are fairly rare in webcams. ;-)

> How should i account this pixel count in my driver.
> How much should be  bytesperline and sizeimage
> How should i account this in my application as well.

I think you will have to play around to see what the exact data format is. 

Cheers,

  Richard

-- 
  __   _
  |_) /|  Richard Atterer     |  GnuPG key: 888354F7
  | \/¯|  http://atterer.net  |  08A9 7B7D 3D13 3EF2 3D25  D157 79E6 F6DC 8883 54F7
  ¯ '` ¯

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
