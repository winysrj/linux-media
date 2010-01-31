Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:45815 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0AaS1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 13:27:08 -0500
Date: Sun, 31 Jan 2010 12:49:16 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: V4L Mailing List <linux-media@vger.kernel.org>
cc: Matthias Huber <matthias.huber@wollishausen.de>
Subject: Re: 0979:0280 :-) (fwd)
Message-ID: <alpine.LNX.2.00.1001311241130.26120@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-1266269036-1264963761=:26120"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-1266269036-1264963761=:26120
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT


This is the first of two mails I am sending. The problem is about a 
jeilinj camera which is not working. The second mail indicates that the 
problem seems to have been in a certain external USB hub, through which 
the camera was connected.

So, one might say the problem is "fixed" but in case there is need to dig 
more deeply I am reporting this. I do find the reported error to be very 
strange, namely (a typical specimen)

Jan 28 17:56:18 linux kernel: [26920.452427] gspca: frame overflow 77885 > 
77824


Please see the next mail, too.

Theodore Kilgore


---------- Forwarded message ----------
Date: Fri, 29 Jan 2010 09:06:26 +0100
From: Matthias Huber <matthias.huber@wollishausen.de>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: 0979:0280 :-)

29.01.2010 02:24,   Theodore Kilgore :
> 
> 
> On Thu, 28 Jan 2010, Matthias Huber wrote:
> 
>> 28.01.2010 20:03,   Theodore Kilgore :
>>> 
>>> 
>>> On Thu, 28 Jan 2010, Matthias Huber wrote:
>>> 
>>>> 28.01.2010 18:36,   Theodore Kilgore :
>>>>> 
>>>>> 
>>>>> On Thu, 28 Jan 2010, Matthias Huber wrote:
>>>>> 
>>>>>> 
>>>>>>>> 
>>>>>>> 
>>>>>>> Well, I guess one needs some more information.
>>>>>>> 
>>>>>>> If jlj_startup() is returning 0 then that is not exactly an error. What 
>>>>>>> else is going on?
>>>>>>> 
>>>>>>> Theodore Kilgore
>>>>>> 
>>>>>> Now i have a few unsuccessful tries:
>>>>>> (problem seems to be here the frame overflow)
>>>>>> 
>>>>>> Jan 28 17:54:48 linux kernel: [26830.766387] jeilinj: deregistered
>>>>>> Jan 28 17:54:56 linux kernel: [26838.306693] gspca: probing 0979:0280
>>>>>> Jan 28 17:54:56 linux kernel: [26838.306701] jeilinj: JEILINJ camera 
>>>>>> detected (vid/pid 0x0979:0x0280)
>>>>>> Jan 28 17:54:56 linux kernel: [26838.306791] gspca: video1 created
>>>>>> Jan 28 17:54:56 linux kernel: [26838.306808] usbcore: registered new 
>>>>>> interface driver jeilinj
>>>>>> Jan 28 17:54:56 linux kernel: [26838.306812] jeilinj: registered
>>>>>> Jan 28 17:55:14 linux matthias: first try
>>>>>> Jan 28 17:55:28 linux kernel: [26870.892905] jeilinj: jlj_start retval 
>>>>>> is 0
>>>>>> Jan 28 17:55:55 linux matthias: result: try was unsuccessful, window 
>>>>>> stayed empty
>>>>>> Jan 28 17:56:16 linux kernel: [26918.931515] jeilinj: jlj_start retval 
>>>>>> is 0
>>>>>> Jan 28 17:56:17 linux kernel: [26919.192148] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:17 linux kernel: [26919.332527] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:17 linux kernel: [26919.496030] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:17 linux kernel: [26919.657412] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:17 linux kernel: [26919.815662] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:17 linux kernel: [26919.975667] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:17 linux kernel: [26920.132793] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:18 linux kernel: [26920.293049] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:18 linux kernel: [26920.452427] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:18 linux kernel: [26920.612805] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:18 linux kernel: [26920.774057] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:24 linux matthias: result: second try was unsuccessful, 
>>>>>> window stayed empty
>>>>>> Jan 28 17:56:35 linux matthias: try three
>>>>>> Jan 28 17:56:37 linux kernel: [26939.307986] jeilinj: jlj_start retval 
>>>>>> is 0
>>>>>> Jan 28 17:56:45 linux matthias: result: try was unsuccessful, window 
>>>>>> stayed empty
>>>>>> Jan 28 17:56:47 linux kernel: [26949.358593] jeilinj: jlj_start retval 
>>>>>> is 0
>>>>>> Jan 28 17:56:47 linux kernel: [26949.601474] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:47 linux kernel: [26949.739477] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:47 linux kernel: [26949.891633] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:47 linux kernel: [26950.048487] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:48 linux kernel: [26950.208738] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:48 linux kernel: [26950.368497] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:48 linux kernel: [26950.528500] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:56:50 linux matthias: result: try was unsuccessful, window 
>>>>>> stayed empty
>>>>>> Jan 28 17:56:52 linux kernel: [26954.171578] jeilinj: jlj_start retval 
>>>>>> is 0
>>>>>> Jan 28 17:57:18 linux matthias: try from user matz
>>>>>> Jan 28 17:57:24 linux kernel: [26987.147964] jeilinj: jlj_start retval 
>>>>>> is 0
>>>>>> Jan 28 17:57:25 linux kernel: [26987.374362] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:57:25 linux kernel: [26987.512100] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:57:25 linux kernel: [26987.650728] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:57:25 linux kernel: [26987.803980] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:57:25 linux kernel: [26987.965110] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:57:25 linux kernel: [26988.123614] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:57:26 linux kernel: [26988.284368] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:57:26 linux kernel: [26988.443495] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:57:26 linux kernel: [26988.607500] gspca: frame overflow 77885 
>>>>>> > 77824
>>>>>> Jan 28 17:58:44 linux kernel: [27066.439232] usbcore: deregistering 
>>>>>> interface driver jeilinj
>>>>>> Jan 28 17:58:44 linux kernel: [27066.439267] gspca: video1 disconnect
>>>>>> Jan 28 17:58:44 linux kernel: [27066.439379] gspca: video1 released
>>>>>> Jan 28 17:58:44 linux kernel: [27066.439398] jeilinj: deregistered
>>>>>> Jan 28 17:58:50 linux kernel: [27072.165450] gspca: probing 0979:0280
>>>>>> Jan 28 17:58:50 linux kernel: [27072.165457] jeilinj: JEILINJ camera 
>>>>>> detected (vid/pid 0x0979:0x0280)
>>>>>> Jan 28 17:58:50 linux kernel: [27072.165544] gspca: video1 created
>>>>>> Jan 28 17:58:50 linux kernel: [27072.165561] usbcore: registered new 
>>>>>> interface driver jeilinj
>>>>>> Jan 28 17:58:50 linux kernel: [27072.165565] jeilinj: registered
>>>>>> Jan 28 17:59:18 linux kernel: [27101.093722] jeilinj: jlj_start retval 
>>>>>> is 0
>>>>>> Jan 28 17:59:48 linux matthias: successful try with errors on the 
>>>>>> commandline
>>>>>> 
>>>>>> 
>>>>>> root@linux:~#  ~matz/bin/svv -d /dev/video1
>>>>>> raw pixfmt: JPEG 320x240
>>>>>> pixfmt: RGB3 320x240
>>>>>> mmap method
>>>>>> libv4lconvert: Error decompressing JPEG: fill_nbits error: need 8 more 
>>>>>> bits
>>>>>> root@linux:~# echo successful try with errors on the commandline | 
>>>>>> logger -t matthias
>>>>> 
>>>>> Hmmm. What I _think_ I see is some complaints that the frame is too long.
>>>>> 
>>>>> A typical one, from above:
>>>>> 
>>>>>> Jan 28 17:57:25 linux kernel: [26987.965110] gspca: frame overflow 77885
>>>>>> 77824
>>>>> 
>>>>> 
>>>>> and then at the end a funny error from libv4lconvert.
>>>>> 
>>>>> This will require further investigation, it seems.
>>>>> 
>>>>> Theodore Kilgore
>>>>> 
>>>> 
>>>> if you need something more from me, feel free to tell me, i will help as 
>>>> much i can.
>>>> 
>>>> 
>>>> -- 
>>>> Mit freundlichen Grüssen
>>>> Matthias Huber Kohlstattstr. 14
>>>> 86459 Wollishausen
>>>> Tel: 08238-7998
>>>> LPI000181125
>>>> 
>>> 
>>> Well, yes. Could you explain whether all of the above messages came from 
>>> debug output, or whether it is that you added some of them by hand, I mean 
>>> things like this one?
>> whenever matthias: stands there it is :
>> # echo whatever debug message should go to syslog | logger -t matthias
>>> 
>>>>>> Jan 28 17:56:45 linux matthias: result: try was unsuccessful, window
>>>>>> stayed empty
>>> 
>>> One of the things to look for is exactly where in the code those error 
>>> messages are coming from. Also the ones about the size being one unit too 
>>> big, of course.
>>> 
>> i didn't find it in jeilinj.c, i think it comes from gspca_main.c, but not 
>> sure.
>>> My preliminary estimate, before having had time to look for such details, 
>>> is that the problem is in v4lconvert and not in the driver code per se. But 
>>> I have not had time yet to search through everything.
>> that  can really be, because under suse linux i hadn't such things.
>> 
>> And: this was my first question: is the tree from the netherlends man really 
>> actual ?
thanks for your correction in your other mail.
My english could be more better and sometimes, i am missing words or are using 
them wrong.
but without correction from outside, it doesn't become better. :-) real thank 
for that.

what i meant, was two things: is it the "correct" tree for the driver and is it 
"recent".
but you answered already in this mail.

>>
>>        ( i used; hg clone http://linuxtv.org/hg/~hgoede/gspca
>> root@linux:/usr/src/gspca# l
>> insgesamt 248
>> -rw-r--r-- 1 root src  18988 2010-01-28 09:37 COPYING
>> -rwxr-xr-x 1 root src   2773 2010-01-28 09:37 hgimport
>> -rw-r--r-- 1 root src   4162 2010-01-28 09:37 INSTALL
>> drwxr-sr-x 8 root src   4096 2010-01-28 09:37 linux
>> -rwxr-xr-x 1 root src   6487 2010-01-28 09:37 mailimport
>> -rw-r--r-- 1 root src   1189 2010-01-28 09:37 Makefile
>> drwxr-sr-x 3 root src   4096 2010-01-28 09:37 media-specs
>> -rw-r--r-- 1 root src    429 2010-01-28 09:37 README
>> -rw-r--r-- 1 root src  26587 2010-01-28 09:37 README.patches
>> drwxr-sr-x 5 root src 155648 2010-01-28 17:50 v4l
>> drwxr-sr-x 6 root src   4096 2010-01-28 09:37 v4l2-apps
>> drwxr-sr-x 3 root src   4096 2010-01-28 09:37 v4l_experimental
>> )
>> 
>> 
>> 
>> and: is the communticaion betweeen kernel-v4l and v4l-libs ok ?
> 
> Should be, yes.
> 
>> 
>> or: do i have to use another tree without some v4l - things ?
>>> 
>>> Theodore Kilgore
> 
> Also it seems that we are almost certainly running the same driver code. I am 
> running it from the tree of Hans de Goede, from which I did a "pull" 
> yesterday in order to synchronize some other stuff. And the error message 
> about "overflow" is coming from gspca.c and no doubt about that. Right now, I 
> am puzzled.
> 
> Theodore Kilgore

can you reproduce this overflow behaviour at home or at work ?

i will try also to find the place but ...
---863829203-1266269036-1264963761=:26120--
