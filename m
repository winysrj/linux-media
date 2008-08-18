Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7I7liL5010669
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 03:47:44 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7I7kxek024824
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 03:46:59 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
In-Reply-To: <48A80FC7.6090909@hhs.nl>
References: <1218734045.1696.39.camel@localhost>  <48A80FC7.6090909@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 18 Aug 2008 09:34:24 +0200
Message-Id: <1219044864.1707.21.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Magic Banana <magicbanana@gmail.com>,
	Video 4 Linux <video4linux-list@redhat.com>
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

On Sun, 2008-08-17 at 13:47 +0200, Hans de Goede wrote:
> Hi Jean, Thomas,

Hi Hans,

> Jean, good to see that you are working on the pixart 73xx support, I 
> have a cam over here as well which didn't work at all, now with your 
> fixes, it atleast generates proper frames (they used too be much too 
> small). Unfortunately my cam still does not work, your siv.c does show 
> something which seems to be decoded video data, but not as it should 
> look like, from the looks of it we are close though.
> 
> I've made a single raw frame from my cam available here:
> http://people.atrpms.net/~hdegoede/image.dat

I forgot to give you the command:

	siv -p PJPG -f 480x640 -d image.dat

('-p PJPG' gives the encoding and '-f 480x640' because the image is
turned to the left).

It is almost black and white with high contrast.

> If anyone can write code which can convert that to an image (might be 
> unsharp) that would be great!
> 
> I've done a first attempt at making v4lconvert handle these pixart jpeg 
> frames, patch attached. Warning this is a crude hack breaking regular 
> jpeg support. This seems to work less well with my cam then the siv.c 
> code, so we might need to make more changes either to v4lconvert, or 
> maybe to the jpeg_put_header call in pac7311.c, talking about this call, 
> since we are defining a custom format anyways, shouldn't we just omit 
> the header and send the jpeg-ish pixart frame data to userspace as is?

About the header, it seems that neither the previous (in pac7311.c), nor
the standard jpeg header (in jpeg.h) give good results.

> Thomas, I would be very much interested in your tinyjpeg version with 
> pixart support!
> 
> Jean, perhaps you can make some raw images from your cam available 
> somewhere too?

I am working with a french guy (Magic Banana, in Cc) who has a webcam
with a 7302 sensor. I put an image extracted from a MS-win trace in my
site:

	http://moinejf.free.fr/pac7302.dat

(I added a jpeg header).

Cheers

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
