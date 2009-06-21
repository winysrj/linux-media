Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:58204 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZFUP1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2009 11:27:55 -0400
Date: Sun, 21 Jun 2009 10:42:47 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@radix.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Sakar 57379 USB Digital Video Camera...
In-Reply-To: <1245557957.3296.215.camel@palomino.walls.org>
Message-ID: <alpine.LNX.2.00.0906211019500.31206@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>  <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>  <1245386416.20630.31.camel@palomino.walls.org>  <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>  <1245435414.4181.7.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>  <1245462845.3168.40.camel@palomino.walls.org>  <alpine.LNX.2.00.0906192253080.18675@banach.math.auburn.edu>  <1245525813.3178.24.camel@palomino.walls.org>  <1245538316.3296.36.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906201956270.28975@banach.math.auburn.edu> <1245557957.3296.215.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 21 Jun 2009, Andy Walls wrote:

> On Sat, 2009-06-20 at 20:04 -0500, Theodore Kilgore wrote:
>>
>
>>>>> Sure looks that way. I took a closer look at the lines starting with ff ff
>>>>> ff ff strings, and I found a couple more things. Here are several lines
>>>>> from an extract from that snoop, consisting of what appear to be
>>>>> consecutive SOF lines.
>>>>>
>>>>>      00000000: ff ff ff ff 00 00 1c 70 3c 00 0f 01 00 00 00 00
>>>>>      00000000: ff ff ff ff 00 00 34 59 1e 00 1b 06 00 00 00 00
>>>>>      00000000: ff ff ff ff 00 00 36 89 1e 00 1c 07 00 00 00 00
>>>>>      00000000: ff ff ff ff 00 00 35 fc 1e 00 1b 08 00 00 00 00
>>>>>      00000000: ff ff ff ff 00 00 35 84 1e 00 1b 09 00 00 00 00
>>>>>
>>>>> The last non-zero byte is a frame counter. Presumably, the gap between the
>>>>> 01 and the 06 occurs because the camera was just then starting up and
>>>>> things were a bit chaotic. The rest of the lines in the file are
>>>>> completely consistent, counting consecutively from 09 to 49 (hex, of
>>>>> course) at which point I killed the stream.
>>>>>
>>>>> The byte previous to that one (reading downwards 0f 1b 1c 1b 1b ...) gives
>>>>> the number of 0x200-byte blocks in that frame, before the next marker
>>>>> comes along. So if we start from the frame labeled "06" then from there on
>>>>> the frames are approximately the same size, but not identical. For example
>>>>> the size of frame 06 is 0x1b*0x200. That is, 27*512 bytes.
>>>
>>> Here's the init for my camera:
>>>
>>> 0000: 71 81
>>> 0000: 70 05
>>> 0000: 95 70
>>> 0000: 00
>>> 0000: 71 81
>>> 0000: 70 04
>>> 0000: 95 70
>>> 0000: 00
>>> 0000: 71 00
>>> 0000: 70 08
>>> 0000: 95 70
>>> 0000: 00
>>> 0000: 94 02
>>> 0000: de 24
>>> 0000: 94 02
>>> 0000: dd f0
>>> 0000: 94 02
>>> 0000: e3 22 <--- different
>>> 0000: 94 02
>>> 0000: e4 00
>>> 0000: 94 02
>>> 0000: e5 00 <--- not repeated like in the sequence above
>>> 0000: 94 02
>>> 0000: e6 22 <--- different
>>> 0000: 94 03
>>> 0000: aa 01 <--- different
>>> 0000: 71 1e
>>> 0000: 70 06
>>> 0000: 71 80
>>> 0000: 70 07
>>>
>>> And here's the terminal sequence:
>>>
>>> 0000: 71 00
>>> 0000: 70 09
>>> 0000: 71 80
>>> 0000: 70 05
>>>
>>> They look amazingly similar to yours.
>>>
>>> Here are the buffers with the supposed SOF marker:
>>>
>>> 0000: ff ff ff ff 00 00 18 43 1e 00 0d fa 00 00 00 00
>>> 0000: ff ff ff ff 00 00 18 26 1e 00 0d 00 00 00 00 00
>>> 0000: ff ff ff ff 00 00 17 fa 1e 00 0c 01 00 00 00 00
>>> 0000: ff ff ff ff 00 00 18 4e 1e 00 0d 02 00 00 00 00
>>> 0000: ff ff ff ff 00 00 18 91 1e 00 0d 03 00 00 00 00
>>> 0000: ff ff ff ff 00 00 18 90 1e 00 0d 04 00 00 00 00
>>> 0000: ff ff ff ff 00 00 18 4b 1e 00 0d 05 00 00 00 00
>>> 0000: ff ff ff ff 00 00 18 8a 1e 00 0d 06 00 00 00 00
>>>
>>> Again very similar.  I had the camera pointed at a mostly white test
>>> target with some large blue numbers printed on it, so the sammler
>>> buffers probably just indicate how simple the test target was.
>>>
>>> The frames from my camera were coming at 100 ms intervals instead of 130
>>> ms intervals.  So maybe some scaling constant has changed with my
>>> supposed frame presentation frequency field that contains 0x1e00.
>
>>
>> This looks quite similar. The differences in the init sequence may be
>> significant, but more likely I would speculate that they are
>> insubstantial. Probably the little differences are due to who actually
>> wrote the camera driver. Those guys over there also put their pants on one
>> leg at a time just like the rest of us, after all. I think they do things
>> like hiring students to write their drivers. If so, they might possibly
>> get the same kind of results that could be expected over here from similar
>> arrangements.
>
> Agree.
>
> The more I dig into this, the more I think (hope or wish?) the stuff in
> the usb snoop logs looks MJPEG.
>
> I started looking at an AVI file that I recorded with the camera.  It
> looks like a DV AVI Type-2 file.
>
> In the AVI file header, my camera reports:
>
> 00000d0: 0000 0000 7374 7264 ac00 0000 4a65 696c  ....strd....Jeil
> 00000e0: 696e 2020 5465 6368 6e6f 6c6f 6779 2043  in  Technology C
> 00000f0: 6f2e 2c20 4c74 642e 4a4c 3230 3038 5632  o., Ltd.JL2008V2
> 0000100: 4330 3037 3030 3130 2020 2020 2020 2020  C0070010
>
> So looking up the JL2008A datasheet, my camera's capabilities match the
> data sheet very well.
>
> http://jeilin.com.tw/eng/product_detail.php?p_id=5
> http://jeilin.com.tw/mana_php/Download/File/JL2008A%20v1.3.pdf
>
> The only video compression that is mentioned on the webpage and in the
> datasheet is JPEG.
>
> Trying to learn about DV AVI Type 2 files I've found roughly how
> individual chunk headers look.  They each have a stream fourcc that
> starts 'nnxx' in ASCII, where nn is the stream number and xx is
>
> db - uncompressed video frame
> dc - compressed video frame
> wb - audio data
>
> $ xxd 00004.avi  | grep -E ' 303[0-2] ((646)|(776))'
>
> 00001f0: 14fe 0c00 6d6f 7669 3031 7762 401f 0000  ....movi01wb@...  <-- audio
> 0002140: 3032 6462 0041 0000 ffe2 55aa 0500 0000  02db.A....U.....  <-- video
> 0006250: 3032 6462 0041 0000 ffe2 55aa 0500 0001  02db.A....U.....  <-- video
> 000a360: 3032 6462 0041 0000 ffe2 55aa 0500 0002  02db.A....U.....  <-- video
> 000e470: 3032 6462 0041 0000 ffe2 55aa 0500 0003  02db.A....U.....  <-- video
> 0012580: 3032 6462 0041 0000 ffe2 55aa 0500 0004  02db.A....U.....  <-- video
> 0016690: 3030 6463 281c 0000 ffd8 ffe0 0016 4156  00dc(.........AV  <-- compressed video
> 00182c0: 3030 6463 e81b 0000 ffd8 ffe0 0016 4156  00dc..........AV  <-- compressed video
> 0019eb0: 3030 6463 c81b 0000 ffd8 ffe0 0016 4156  00dc..........AV  <-- compressed video
>
>> From the AVI header and from the compressed video chunk headers, the
> compressed video stream is MJPEG.
>
> I don't know what the uncompressed video (02db) chunks are.  The AVI
> header doesn't mention a third stream (stream 02).  The length of each
> chunk of this third stream is 0x4100 = 0x20 * 0x200 and each one has an
> incrementing sequence number in the header.
>
> Doing some math:
>
> 320 * 240 = 76800 = 0x12c00
>
> 0x12c00 / 0x4100 = 0x4.9d = 4.61
>
> so 5 chunks of 0x4100 bytes would be needed for one uncompressed 320x240
> frame at 8 bits/pixel.  Those uncompressed video chunks always come in
> groups of 5 in the AVI file.
>
>
> The idx section at the end of the AVI file only indexes the compressed
> video (00dc) and audio (01wb) chunks:
>
> 00d0000: 0000 0000 0000 0000 6964 7831 4005 0000  ........idx1@...
> 00d0010: 3031 7762 0000 0000 0400 0000 401f 0000  01wb........@...
> 00d0020: 3030 6463 1000 0000 9c64 0100 281c 0000  00dc.....d..(...
> 00d0030: 3030 6463 1000 0000 cc80 0100 e81b 0000  00dc............
> 00d0040: 3030 6463 1000 0000 bc9c 0100 c81b 0000  00dc............
> 00d0050: 3030 6463 1000 0000 8cb8 0100 f81b 0000  00dc............
> 00d0060: 3030 6463 1000 0000 8cd4 0100 581c 0000  00dc........X...
>
>
> My tired eyes are telling me the AVI file's MJPEG compressed video
> stream (00dc) looks like what comes out of the camera in webcam mode
> than the AVI file's uncompressed video stream.
>
> The first 0x110 bytes of the MJPEG stream (00dc) chunks in the AVI file
> remain invariant, except for 3, 32 bit values related to length: The AVI
> stream 00dc chunk length and the MJPEG AVI1 App's field size and padded
> field size (I think).
>
> 0099560: 30 30 64 63 78 0e 00 00 ff d8 ff e0 00 16 41 56  00dcx.........AV
>                     ^^^^^^^^^^^--- Chunk/padded length
> 0099570: 49 31 00 00 78 0e 00 00 71 0e 00 00 00 00 00 00  I1..x...q.......
>                     ^^^^^^^^^^^ ^^^^^^^^^^^ --- actual length
> 0099580: 00 00 ff dd 00 04 00 00 ff db 00 c5 00 14 0e 0f  ................
> 0099590: 12 0f 0d 14 12 10 12 17 15 14 18 1e 32 21 1e 1c  ............2!..
> 00995a0: 1c 1e 3d 2c 2e 24 32 49 40 4c 4b 47 40 46 45 50  ..=,.$2I@LKG@FEP
> 00995b0: 5a 73 62 50 55 6d 56 45 46 64 88 65 6d 77 7b 81  ZsbPUmVEFd.emw{.
> 00995c0: 82 81 4e 60 8d 97 8c 7d 96 73 7e 81 7c 01 15 17  ..N`...}.s~.|...
> 00995d0: 17 1e 1a 1e 3b 21 21 3b 7c 53 46 53 7c 7c 7c 7c  ....;!!;|SFS||||
> 00995e0: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c  ||||||||||||||||
> 00995f0: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c  ||||||||||||||||
> 0099600: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 02 15  ||||||||||||||..
> 0099610: 17 17 1e 1a 1e 3b 21 21 3b 7c 53 46 53 7c 7c 7c  .....;!!;|SFS|||
> 0099620: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c  ||||||||||||||||
> 0099630: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c  ||||||||||||||||
> 0099640: 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c ff  |||||||||||||||.
> 0099650: c0 00 11 08 00 f0 01 40 03 01 22 00 02 11 01 03  .......@..".....
> 0099660: 11 02 ff da 00 0c 03 01 00 02 11 03 11 00 3f 00  ..............?.
>         (end of the invariant portion of an MJPEG chunk in an AVI file)
>
> 0099670: a1 46 73 d3 f9 51 ce 3e b4 77 e6 82 ec 02 83 e9  .Fs..Q.>.w......
> 0099680: 8a 3b d1 d3 a5 2b 88 07 4a 4e a4 d1 da 97 de 90  .;...+..JN......
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                                     |
> First 32 bytes of the MJPEG chunk payload data that varies.
>
>
> The invariant, MJPEG header portion contains some quantization tables, a
> SOS marker, and SOF marker etc.
>
> The payload after the SOS marker (ff da 00 0c 03 01 00 02 11 03 11 00 3f 00)
> reminds me a lot of what the camera puts out in webcam mode.
>
> I suppose if you've seen one blob of Huffman coded data, you've seen
> them all, so the webcam mode could be putting out something wildly
> different from MJPEG data.  However, I'm betting that the webcam uses an
> implicit MJPEG header and only sends the encoded data.
>
>
>> As to
>>
>>> 0000: e5 00 <--- not repeated like in the sequence above
>>
>> that was a transcription error on my part, committed by using the mouse to
>> copy something in two pieces that was too long to copy at once. Check the
>> log I sent along. But I think it is not really there.
>
> OK.  I'm not too concerned about this at the moment.

Well, it appears that there are a couple of ways to go:

1. Get busy and write a driver that will get the raw data out, so that it 
can be inspected. Once that is done, then, quoting the White Knight 
in Lewis Carroll, "Either it brings tears to your eyes, or it doesn't."

2. Take some of the snoop log output and convert it by hand to a binary 
file, so that it can actually be looked at with hexdump to see if similar 
clues are present. I have a few tools that, while not making this 
automatic, do make the job not too too unpleasant.

As far as the log output or raw data is concerned, one can look of course 
for JPEG headers. But (admittedly only after a cursory glance) I am 
suspecting that they are not yet present in the raw data from the camera. 
Clearly, it would be nice to be wrong.

As to what MJPEG output looks like, in fact I have no experience with it 
at all. I also do not know how to make my camera to do an AVI file. It 
is a standard capability for many of these cheap dual-mode cameras, to do 
a short "movie clip," but I have misplaced the manual and would have to 
guess about how to press the magic sequence of buttons to make the camera 
do that. And I am also not sure what I will learn if I do make it work, 
which is relevant to the somewhat different functionality of streaming. It 
will be interesting if I can pull up a header like yours. We would 
actually know, then, that Jeilin says we have the same camera under the 
hood.

I can try to look into some of these things.

Theodore Kilgore
