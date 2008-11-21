Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAL8WW1Q029537
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 03:32:32 -0500
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAL8WHjj031253
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 03:32:18 -0500
Message-ID: <49267361.9030703@hhs.nl>
Date: Fri, 21 Nov 2008 09:37:53 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
	<200811190020.15663.linux@baker-net.org.uk>
	<4923D159.9070204@hhs.nl>
	<alpine.LNX.1.10.0811192005020.2980@banach.math.auburn.edu>
	<49253004.4010504@hhs.nl>
	<Pine.LNX.4.64.0811201130410.3570@banach.math.auburn.edu>
	<4925BC94.7090008@hhs.nl>
	<Pine.LNX.4.64.0811201657020.3763@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811201657020.3763@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, sqcam-devel@lists.sourceforge.net
Subject: Re: [sqcam-devel] Advice wanted on producing an in kernel sq905
	driver
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

kilgota@banach.math.auburn.edu wrote:
> 

<snip>

> 
>> Easiest way to get my latest code is here:
>> http://people.atrpms.net/~hdegoede/libv4l-0.5.5.tar.gz
>>
>> You are looking for libv4lconvert/bayer.c
> 
> Thanks. I got it. By your leave, the first thing I will do is to try to 
> speed up my own code. There are, I think, some real possibilities to do 
> that. However, without looking at any details of what you did in your 
> bayer.c, I will ask a question about organization of the way you did 
> things. What happens in libgphoto2 is, first a function is run which 
> "spreads out" the (uncompressed) raw data to a block of data of size 
> 3*w*h, so that each byte of actual data is in its natural place in the 
> finished image and the rest of the locations in the finished image are 
> left filled with 00 bytes. Then after this what the algorithm does is to 
> work on this copy of the still-not-finished image and to finish it, 
> entering each piece of computed or estimated data in its proper 
> location. There might be other ways to go about the entire project of 
> doing the Bayer demosaicing. Therefore, I ask whether you have done 
> things the same way, or did you take one of those other possible routes 
> to the final result? For example, in
> 
> static void bayer_to_rgbbgr24(const unsigned char *bayer,
>   unsigned char *bgr, int width, int height, unsigned int pixfmt,
>         int start_with_green, int blue_line)
> 
> (which looks like one of the relevant functions) is bgr of size w*h, 
> (size of uncompressed input) still, or of size 3*w*h (size of 
> interpolated RGB output)? I could figure out all of this stuff in 3 
> days, but probably not in 5 minutes.
> 

bayer is the raw bayer input here, and that is ofcourse w*h, bgr is w*3*h, and 
when this function is done contains complete rgb triplets for all pixels. This 
function does the "spread out" and the interpolating in one pass.

<snip>

>> p.s.
>>
>> If you are experienced with reverse engineering decompression 
>> algorithms 9for raw bayer), I've got multiple issues where you could 
>> help me.
>>
> 
> Haha. I was about to ask you the same. On my end, this is *the* problem. 

Hehe

<snip>

> As to the cameras I mentioned before, and who figured out the 
> decompression:
> 
> SQ905 and 905C     myself (took several years to get it all done right)
> 
> SN9C2028     macam project, with some improvements by myself after they 
> did the hard work. The code from the macam project was based, in turn, 
> on the work of Bertrik Sikkens on the SN9C10X cameras. The two 
> algorithms are similar but not identical.
> 

Interesting, so you are familiar with the sn9c10x bayer compression, as you 
then may remeber it uses differential compression with the following huffman codes:
0
100
101
1101
1111
11001
110000
1110xxxx /* direct set */

But sometimes it also sends:
110001xx

And we have no idea what this code means, does the sn9c2028 also have something 
similar and have you figured it out?

> MR97310 Bertrik figured out some of the basic stuff but it was never 
> right, until I was finally (after years) able to figure out what was 
> wrong. Again this is a differential Huffman encoding which is similar to 
> the one the Sonix cameras are using, but again different in details.
> 
> You want quick, go and ask Bertrik. He is, in my experience, either very 
> clever or very lucky.
> 

Ok, I'll ask him.

Thanks & Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
