Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51664 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbZFVBgE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2009 21:36:04 -0400
Subject: Re: Sakar 57379 USB Digital Video Camera...
From: Andy Walls <awalls@radix.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0906211019500.31206@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>
	 <1245386416.20630.31.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>
	 <1245435414.4181.7.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>
	 <1245462845.3168.40.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906192253080.18675@banach.math.auburn.edu>
	 <1245525813.3178.24.camel@palomino.walls.org>
	 <1245538316.3296.36.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906201956270.28975@banach.math.auburn.edu>
	 <1245557957.3296.215.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906211019500.31206@banach.math.auburn.edu>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 21:37:47 -0400
Message-Id: <1245634667.3815.54.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-06-21 at 10:42 -0500, Theodore Kilgore wrote:
> 
> On Sun, 21 Jun 2009, Andy Walls wrote:

> > The more I dig into this, the more I think (hope or wish?) the stuff in
> > the usb snoop logs looks MJPEG.
> >
> > I started looking at an AVI file that I recorded with the camera.  It
> > looks like a DV AVI Type-2 file.
> >
> > In the AVI file header, my camera reports:
> >
> > 00000d0: 0000 0000 7374 7264 ac00 0000 4a65 696c  ....strd....Jeil
> > 00000e0: 696e 2020 5465 6368 6e6f 6c6f 6779 2043  in  Technology C
> > 00000f0: 6f2e 2c20 4c74 642e 4a4c 3230 3038 5632  o., Ltd.JL2008V2
> > 0000100: 4330 3037 3030 3130 2020 2020 2020 2020  C0070010
> >
> > So looking up the JL2008A datasheet, my camera's capabilities match the
> > data sheet very well.
> >
> > http://jeilin.com.tw/eng/product_detail.php?p_id=5
> > http://jeilin.com.tw/mana_php/Download/File/JL2008A%20v1.3.pdf
> >
> > The only video compression that is mentioned on the webpage and in the
> > datasheet is JPEG.
> >
> > Trying to learn about DV AVI Type 2 files I've found roughly how
> > individual chunk headers look.  They each have a stream fourcc that
> > starts 'nnxx' in ASCII, where nn is the stream number and xx is
> >
> > db - uncompressed video frame
> > dc - compressed video frame
> > wb - audio data
> >
> > $ xxd 00004.avi  | grep -E ' 303[0-2] ((646)|(776))'
> >
> > 00001f0: 14fe 0c00 6d6f 7669 3031 7762 401f 0000  ....movi01wb@...  <-- audio
> > 0002140: 3032 6462 0041 0000 ffe2 55aa 0500 0000  02db.A....U.....  <-- video
> > 0006250: 3032 6462 0041 0000 ffe2 55aa 0500 0001  02db.A....U.....  <-- video
> > 000a360: 3032 6462 0041 0000 ffe2 55aa 0500 0002  02db.A....U.....  <-- video
> > 000e470: 3032 6462 0041 0000 ffe2 55aa 0500 0003  02db.A....U.....  <-- video
> > 0012580: 3032 6462 0041 0000 ffe2 55aa 0500 0004  02db.A....U.....  <-- video
> > 0016690: 3030 6463 281c 0000 ffd8 ffe0 0016 4156  00dc(.........AV  <-- compressed video
> > 00182c0: 3030 6463 e81b 0000 ffd8 ffe0 0016 4156  00dc..........AV  <-- compressed video
> > 0019eb0: 3030 6463 c81b 0000 ffd8 ffe0 0016 4156  00dc..........AV  <-- compressed video
> >
> >> From the AVI header and from the compressed video chunk headers, the
> > compressed video stream is MJPEG.
> >
> > I don't know what the uncompressed video (02db) chunks are.  The AVI
> > header doesn't mention a third stream (stream 02).  The length of each
> > chunk of this third stream is 0x4100 = 0x20 * 0x200 and each one has an
> > incrementing sequence number in the header.
> >
> > Doing some math:
> >
> > 320 * 240 = 76800 = 0x12c00
> >
> > 0x12c00 / 0x4100 = 0x4.9d = 4.61
> >
> > so 5 chunks of 0x4100 bytes would be needed for one uncompressed 320x240
> > frame at 8 bits/pixel.  Those uncompressed video chunks always come in
> > groups of 5 in the AVI file.
> >
> >
> > The idx section at the end of the AVI file only indexes the compressed
> > video (00dc) and audio (01wb) chunks:
> >
> > 00d0000: 0000 0000 0000 0000 6964 7831 4005 0000  ........idx1@...
> > 00d0010: 3031 7762 0000 0000 0400 0000 401f 0000  01wb........@...
> > 00d0020: 3030 6463 1000 0000 9c64 0100 281c 0000  00dc.....d..(...
> > 00d0030: 3030 6463 1000 0000 cc80 0100 e81b 0000  00dc............
> > 00d0040: 3030 6463 1000 0000 bc9c 0100 c81b 0000  00dc............
> > 00d0050: 3030 6463 1000 0000 8cb8 0100 f81b 0000  00dc............
> > 00d0060: 3030 6463 1000 0000 8cd4 0100 581c 0000  00dc........X...
> >
> >
> > My tired eyes are telling me the AVI file's MJPEG compressed video
> > stream (00dc) looks like what comes out of the camera in webcam mode
> > than the AVI file's uncompressed video stream.
> >
> > The first 0x110 bytes of the MJPEG stream (00dc) chunks in the AVI file
> > remain invariant, except for 3, 32 bit values related to length: The AVI
> > stream 00dc chunk length and the MJPEG AVI1 App's field size and padded
> > field size (I think).
> >
> > 0099560: 30 30 64 63 78 0e 00 00 ff d8 ff e0 00 16 41 56  00dcx.........AV
> >                     ^^^^^^^^^^^--- Chunk/padded length
> > 0099570: 49 31 00 00 78 0e 00 00 71 0e 00 00 00 00 00 00  I1..x...q.......
> >                     ^^^^^^^^^^^ ^^^^^^^^^^^ --- actual length
> > 0099580: 00 00 ff dd 00 04 00 00 ff db 00 c5 00 14 0e 0f  ................
> > 0099590: 12 0f 0d 14 12 10 12 17 15 14 18 1e 32 21 1e 1c  ............2!..
> > 00995a0: 1c 1e 3d 2c 2e 24 32 49 40 4c 4b 47 40 46 45 50  ..=,.$2I@LKG@FEP
> > 00995b0: 5a 73 62 50 55 6d 56 45 46 64 88 65 6d 77 7b 81  ZsbPUmVEFd.emw{.
> > 00995c0: 82 81 4e 60 8d 97 8c 7d 96 73 7e 81 7c 01 15 17  ..N`...}.s~.|...
> > 00995d0: 17 1e 1a 1e 3b 21 21 3b 7c 53 46 53 7c 7c 7c 7c  ....;!!;|SFS||||
> > 00995e0: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c  ||||||||||||||||
> > 00995f0: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c  ||||||||||||||||
> > 0099600: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 02 15  ||||||||||||||..
> > 0099610: 17 17 1e 1a 1e 3b 21 21 3b 7c 53 46 53 7c 7c 7c  .....;!!;|SFS|||
> > 0099620: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c  ||||||||||||||||
> > 0099630: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c  ||||||||||||||||
> > 0099640: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c ff  |||||||||||||||.
> > 0099650: c0 00 11 08 00 f0 01 40 03 01 22 00 02 11 01 03  .......@..".....
> > 0099660: 11 02 ff da 00 0c 03 01 00 02 11 03 11 00 3f 00  ..............?.
> >         (end of the invariant portion of an MJPEG chunk in an AVI file)
> >
> > 0099670: a1 46 73 d3 f9 51 ce 3e b4 77 e6 82 ec 02 83 e9  .Fs..Q.>.w......
> > 0099680: 8a 3b d1 d3 a5 2b 88 07 4a 4e a4 d1 da 97 de 90  .;...+..JN......
> >         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >                                     |
> > First 32 bytes of the MJPEG chunk payload data that varies.
> >
> >
> > The invariant, MJPEG header portion contains some quantization tables, a
> > SOS marker, and SOF marker etc.
> >
> > The payload after the SOS marker (ff da 00 0c 03 01 00 02 11 03 11 00 3f 00)
> > reminds me a lot of what the camera puts out in webcam mode.
> >
> > I suppose if you've seen one blob of Huffman coded data, you've seen
> > them all, so the webcam mode could be putting out something wildly
> > different from MJPEG data.  However, I'm betting that the webcam uses an
> > implicit MJPEG header and only sends the encoded data.
> >

> Well, it appears that there are a couple of ways to go:
> 
> 1. Get busy and write a driver that will get the raw data out, so that it 
> can be inspected. Once that is done, then, quoting the White Knight 
> in Lewis Carroll, "Either it brings tears to your eyes, or it doesn't."
> 
> 2. Take some of the snoop log output and convert it by hand to a binary 
> file, so that it can actually be looked at with hexdump to see if similar 
> clues are present. I have a few tools that, while not making this 
> automatic, do make the job not too too unpleasant.
> 
> As far as the log output or raw data is concerned, one can look of course 
> for JPEG headers. But (admittedly only after a cursory glance) I am 
> suspecting that they are not yet present in the raw data from the camera. 
> Clearly, it would be nice to be wrong.

I suspect neither JPEG (JFIF, TIFF/JPEG, EXIF) nor MJPEG (Apple
QuickTime, MS AVI) headers are there.  They should look very different
from the data payload we see.

A quick 'strings -a jl2008.sys' reveals 'JFIF' and 'MJPG' both appearing
once and 'vids' appearing several times.  That leads me to suspect the
driver may be building JFIF JPEG stills or MS AVI MJPEG streams using
data from the device.



> As to what MJPEG output looks like, in fact I have no experience with it 
> at all.

For the file formats, for which there is no real standard (except for
Motion JPEG 2000 which has an ISO/IEC document):

Some education and history:
http://www.digitalpreservation.gov/formats/fdd/video_fdd.shtml
http://www.digitalpreservation.gov/formats/fdd/fdd000060.shtml
http://www.digitalpreservation.gov/formats/fdd/fdd000089.shtml
http://en.wikipedia.org/wiki/MJPEG
http://en.wikipedia.org/wiki/Audio_Video_Interleave#DV_AVI

Some actual, but partial specification:
http://msdn.microsoft.com/en-us/library/ms779636.aspx
http://msdn.microsoft.com/en-us/library/ms783421(VS.85).aspx
http://developer.apple.com/documentation/QuickTime/QTFF/qtff.pdf

So looking at the above resources (especially the Apple doc), I can
decode a little of the above RIFF/AVI chunk that holds MJPEG data.

0099560: 30 30 64 63 78 0e 00 00  - RIFF/AVI chunk header, stream '00', 'dc' -> compressed video, chunk payload length 0xe78(?)

0099568: ff d8 - JPEG start of image marker

009956a: ff e0  00 16 41 56 49 31 00 00 78 0e 00 00 71 0e 00 00 00 00 00 00 00 00 
MJPEG App0(?) marker, marker content length 0x16, App name 'AVI1', padded lenght 0xe78, actual length 0xe71

0099582: ff dd 00 04 00 00 - JPEG marker 0xff 0xdd, marker content length 4 (I don't know)

0099588: ff db 00 c5 - JPEG Quantization table marker, marker content length 0xc5

009958c: 00 - Y quantization table
009958d: 14 0e 0f 12 0f 0d 14 12 10 12 17 15 14 18 1e 32 21 1e 1c
00995a0: 1c 1e 3d 2c 2e 24 32 49 40 4c 4b 47 40 46 45 50 
00995b0: 5a 73 62 50 55 6d 56 45 46 64 88 65 6d 77 7b 81
00995c0: 82 81 4e 60 8d 97 8c 7d 96 73 7e 81 7c

00995cd: 01 - Pr(?) quantization table
00995ce: 15 17 17 1e 1a 1e 3b 21 21 3b 7c 53 46 53 7c 7c 7c 7c 
00995e0: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c
00995f0: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c
0099600: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 
> 
009960e: 02 - Pb(?) qunatization table
009960f: 15 17 17 1e 1a 1e 3b 21 21 3b 7c 53 46 53 7c 7c 7c
0099620: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c
0099630: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c
0099640: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 

009964f: ff c0 00 11 08 00 f0 01 40 03 01 22 00 02 11 01 03 11 02
(M?)JPEG Start of Frame Marker, marker length 0x11, 8 bpp?, 0x00f0 x 0x0140 (240 by 320), ...

0099662: ff da 00 0c 03 01 00 02 11 03 11 00 3f 00  
(M?)JPEG Start of Stream Marker, marker conten length 0xc, ....

0099670: a1 46 73 d3 f9 51 ce 3e b4 77 e6 82 ec 02 83 e9  .Fs..Q.>.w......
0099680: 8a 3b d1 d3 a5 2b 88 07 4a 4e a4 d1 da 97 de 90  .;...+..JN......
Beginning of entropy coded data....


Notice with MJPEG, there is no explicit Huffman table specified.  It is
fixed and implicit.  MJPEG decoders have to know to tack the proper
Huffman table in place before sending a frame to a JPEG decoder.



> I also do not know how to make my camera to do an AVI file. It 
> is a standard capability for many of these cheap dual-mode cameras, to do 
> a short "movie clip," but I have misplaced the manual and would have to 
> guess about how to press the magic sequence of buttons to make the camera 
> do that.

On my camera, when the USB cable is not connected, the "mode" button
switches between taking stills or videos.  The videos show up on the
mass storage device as *.avi files.



>  And I am also not sure what I will learn if I do make it work, 
> which is relevant to the somewhat different functionality of streaming.

I'm not sure either.  I tend to work problems with lots of unknowns with
two rules of thumb:

1. Use all the available information you can find.
2. If the answers aren't where you are looking, they must be somewhere
else.

I think the best information I gleaned from the AVI file was higher
confidence that I was looking at JPEG image data in the USB trace logs,
and that the usb trace was devoid of useful JPEG or MJPEG header
information.

The product information on the JL2008 let me know that the only realtime
compression engine on the chip is JPEG. 

>  It 
> will be interesting if I can pull up a header like yours. We would 
> actually know, then, that Jeilin says we have the same camera under the 
> hood.

The EXIF header in the JPEG stills captured by the camera has this
identifier in it:

0000090: 0000 4a45 494c 494e 2054 4543 482e 5151  ..JEILIN TECH.QQ
00000a0: 2044 5630 344f b400 0000 0100 0000 b400   DV04O..........
00000b0: 0000 0100 0000 4330 3037 3030 3130 000c  ......C0070010..
00000c0: 0200 9208 0200 9e1c 0200 b614 0200 d208  ................
00000d0: 0502 3230 3036 3a30 373a 3236 2031 313a  ..2006:07:26 11:
00000e0: 3030 3a30 3000 2200 9a82 0500 0100 0000  00:00.".........

I love that I get a timestamp from a camera with no user accessable
clock. :)


I will send you a private email with a JPEG still and an AVI file taken
by the camera of the same test target (I think) that I used when
producing the usb snoop logs.

> I can try to look into some of these things.


Please do.  I have time to research, but not too much time to do decent
coding.  During research, I can easily recover from normal household
interruptions; during coding, not so well.


Regards,
Andy

> Theodore Kilgore
> 

