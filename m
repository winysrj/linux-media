Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5FDNuF4030735
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 09:23:56 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au
	(outbound.icp-qv1-irony-out3.iinet.net.au [203.59.1.148])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5FDNZOx029748
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 09:23:36 -0400
Message-ID: <485517D8.5040607@iinet.net.au>
Date: Sun, 15 Jun 2008 21:23:36 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <48513259.6030003@iinet.net.au>	<20080615083447.4d288a9e@gaivota>	<4855044D.7000702@iinet.net.au>	<4855085A.8070002@iinet.net.au>
	<20080615092942.312627a1@gaivota>
In-Reply-To: <20080615092942.312627a1@gaivota>
Content-Type: multipart/mixed; boundary="------------040201040100090908070606"
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [PATCH] Avermedia A16d Avermedia E506
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

This is a multi-part message in MIME format.
--------------040201040100090908070606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mauro Carvalho Chehab wrote:
> On Sun, 15 Jun 2008 20:17:30 +0800
> timf <timf@iinet.net.au> wrote:
>
>   
>> timf wrote:
>>     
>>> Mauro Carvalho Chehab wrote:
>>>       
>>>> On Thu, 12 Jun 2008 22:27:37 +0800
>>>> timf <timf@iinet.net.au> wrote:
>>>>
>>>>  
>>>>         
>>>>> Hi Mauro,
>>>>>
>>>>> OK, Herewith find the patch for the Avermedia A16d, and the 
>>>>> Avermedia E506 Cardbus.
>>>>> I am using Thunderbird, so as well as pasting it here I shall attach 
>>>>> it.
>>>>> DVB-T, Analog-TV, FM-Radio - work for both cards.
>>>>> Composite, S-Video not tested.
>>>>>
>>>>> Regards,
>>>>> Timf
>>>>>
>>>>> Signed-off-by: Tim Farrington <timf@iinet.net.au>
>>>>>
>>>>>     
>>>>>           
>>>> Hi Tim,
>>>>
>>>> Your patch didn't apply:
>>>>
>>>> $ patch -p1 -i /home/v4l/tmp/mailimport23503/patch.diff
>>>> patching file linux/drivers/media/common/ir-keymaps.c
>>>> Hunk #1 succeeded at 2251 with fuzz 1.
>>>> missing header for unified diff at line 898 of patch
>>>> patching file linux/drivers/media/video/saa7134/saa7134-cards.c
>>>> Hunk #1 FAILED at 4232.
>>>> Hunk #2 FAILED at 4259.
>>>> Hunk #3 FAILED at 4272.
>>>> Hunk #4 FAILED at 5503.
>>>> Hunk #5 FAILED at 5727.
>>>> Hunk #6 FAILED at 5739.
>>>> Hunk #7 FAILED at 5865.
>>>> 7 out of 7 hunks FAILED -- saving rejects to file 
>>>> linux/drivers/media/video/saa7134/saa7134-cards.c.rej
>>>> patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
>>>> Hunk #1 FAILED at 153.
>>>> Hunk #2 FAILED at 212.
>>>> patch: **** malformed patch at line 1073: &avermedia_xc3028_mt352_dev,
>>>>
>>>> Also, running checkpatch.pl generates lots of codingstyle errors and 
>>>> warnings.
>>>>
>>>> Please, re-generate it against the latest tree, fix coding style and 
>>>> be sure
>>>> that your emailer is not breaking long lines or replacing tabs with 
>>>> spaces. If
>>>> you're using thunderbird, maybe it would be better to send, instead, 
>>>> as an
>>>> attachment.
>>>>
>>>>
>>>>
>>>> Cheers,
>>>> Mauro
>>>>
>>>>   
>>>>         
>>> Hi Mauro,
>>> I'm a lttle confused.
>>> I simply cloned via hg into a directory.
>>> I copied that v4l-dvb as v4l-dvb-a16d-e506.
>>> I then modified v4l-dvb-a16d-e506 with my mods.
>>> I then did: diff -upr v4l-dvb v4l-dvb-a16d-e506r
>>> I made a 2nd copy of v4l-dvb in another directory.
>>> In that 2nd directory I did: patch -p0 < v4l-dvb-a16d-e506.diff
>>> I had no errors.
>>> I then did diff -upr ../v4l-dvb v4l-dvb-a16d-e506
>>> which produced no differences.
>>> I applied checkpatch.pl with no errors.
>>> I then emailed you the v4l-dvb-a16d-e506.diff file as an attachment.
>>>
>>>
>>> I have tried using hg diff ...
>>> but it bails out with a message about mine not being a mercurial 
>>> depository.
>>>
>>> Did you check with the attachment? as I said in the email that I was 
>>> using Thunderbird.
>>>
>>> When I produced the patch, it was against the then current mercurial, 
>>> 3 days ago.
>>>
>>> Regards,
>>> Tim Farrington
>>>
>>> -- 
>>> video4linux-list mailing list
>>> Unsubscribe 
>>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>
>>>       
>> I just downloaded latest hg
>> Then tried patch.
>> result at command line:
>> timf@ubuntu:~/1/try1$ patch -p0 < v4l-dvb-a16d-e506.diff
>> patching file v4l-dvb/linux/drivers/media/common/ir-keymaps.c
>> patching file v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
>> Hunk #7 succeeded at 5866 (offset 1 line).
>> patching file v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c
>> Hunk #4 succeeded at 1254 (offset 1 line).
>> patching file v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c
>> patching file v4l-dvb/linux/include/media/ir-common.h
>> timf@ubuntu:~/1/try1$
>>
>> I will attach diff file again
>>     
>
> Much better. Probably, Thunderbird broke your patch.
>
> Yet, there are lots of checkpacth complains [1]. Could you please fix they and
> re-send it to us?
>
> [1] if you've got the tree with "hg clone http://linuxtv.org/hg/v4l-dvb", you
> can just do "make checkpatch" to get those errors.
>
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x20 ] = KEY_LIST,':
> linux/drivers/media/common/ir-keymaps.c:2256: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x20 ] = KEY_LIST,':
> linux/drivers/media/common/ir-keymaps.c:2256: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x00 ] = KEY_POWER,':
> linux/drivers/media/common/ir-keymaps.c:2257: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x00 ] = KEY_POWER,':
> linux/drivers/media/common/ir-keymaps.c:2257: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x28 ] = KEY_1,':
> linux/drivers/media/common/ir-keymaps.c:2258: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x28 ] = KEY_1,':
> linux/drivers/media/common/ir-keymaps.c:2258: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x18 ] = KEY_2,':
> linux/drivers/media/common/ir-keymaps.c:2259: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x18 ] = KEY_2,':
> linux/drivers/media/common/ir-keymaps.c:2259: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x38 ] = KEY_3,':
> linux/drivers/media/common/ir-keymaps.c:2260: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x38 ] = KEY_3,':
> linux/drivers/media/common/ir-keymaps.c:2260: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x24 ] = KEY_4,':
> linux/drivers/media/common/ir-keymaps.c:2261: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x24 ] = KEY_4,':
> linux/drivers/media/common/ir-keymaps.c:2261: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x14 ] = KEY_5,':
> linux/drivers/media/common/ir-keymaps.c:2262: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x14 ] = KEY_5,':
> linux/drivers/media/common/ir-keymaps.c:2262: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x34 ] = KEY_6,':
> linux/drivers/media/common/ir-keymaps.c:2263: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x34 ] = KEY_6,':
> linux/drivers/media/common/ir-keymaps.c:2263: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2c ] = KEY_7,':
> linux/drivers/media/common/ir-keymaps.c:2264: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2c ] = KEY_7,':
> linux/drivers/media/common/ir-keymaps.c:2264: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x1c ] = KEY_8,':
> linux/drivers/media/common/ir-keymaps.c:2265: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x1c ] = KEY_8,':
> linux/drivers/media/common/ir-keymaps.c:2265: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3c ] = KEY_9,':
> linux/drivers/media/common/ir-keymaps.c:2266: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3c ] = KEY_9,':
> linux/drivers/media/common/ir-keymaps.c:2266: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x12 ] = KEY_SUBTITLE,':
> linux/drivers/media/common/ir-keymaps.c:2267: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x12 ] = KEY_SUBTITLE,':
> linux/drivers/media/common/ir-keymaps.c:2267: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x22 ] = KEY_0,':
> linux/drivers/media/common/ir-keymaps.c:2268: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x22 ] = KEY_0,':
> linux/drivers/media/common/ir-keymaps.c:2268: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x32 ] = KEY_REWIND,':
> linux/drivers/media/common/ir-keymaps.c:2269: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x32 ] = KEY_REWIND,':
> linux/drivers/media/common/ir-keymaps.c:2269: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3a ] = KEY_SHUFFLE,':
> linux/drivers/media/common/ir-keymaps.c:2270: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3a ] = KEY_SHUFFLE,':
> linux/drivers/media/common/ir-keymaps.c:2270: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x02 ] = KEY_PRINT,':
> linux/drivers/media/common/ir-keymaps.c:2271: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x02 ] = KEY_PRINT,':
> linux/drivers/media/common/ir-keymaps.c:2271: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x11 ] = KEY_CHANNELDOWN,':
> linux/drivers/media/common/ir-keymaps.c:2272: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x11 ] = KEY_CHANNELDOWN,':
> linux/drivers/media/common/ir-keymaps.c:2272: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x31 ] = KEY_CHANNELUP,':
> linux/drivers/media/common/ir-keymaps.c:2273: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x31 ] = KEY_CHANNELUP,':
> linux/drivers/media/common/ir-keymaps.c:2273: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0c ] = KEY_ZOOM,':
> linux/drivers/media/common/ir-keymaps.c:2274: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0c ] = KEY_ZOOM,':
> linux/drivers/media/common/ir-keymaps.c:2274: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x1e ] = KEY_VOLUMEDOWN,':
> linux/drivers/media/common/ir-keymaps.c:2275: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x1e ] = KEY_VOLUMEDOWN,':
> linux/drivers/media/common/ir-keymaps.c:2275: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3e ] = KEY_VOLUMEUP,':
> linux/drivers/media/common/ir-keymaps.c:2276: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3e ] = KEY_VOLUMEUP,':
> linux/drivers/media/common/ir-keymaps.c:2276: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0a ] = KEY_MUTE,':
> linux/drivers/media/common/ir-keymaps.c:2277: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0a ] = KEY_MUTE,':
> linux/drivers/media/common/ir-keymaps.c:2277: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x04 ] = KEY_AUDIO,':
> linux/drivers/media/common/ir-keymaps.c:2278: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x04 ] = KEY_AUDIO,':
> linux/drivers/media/common/ir-keymaps.c:2278: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x26 ] = KEY_RECORD,':
> linux/drivers/media/common/ir-keymaps.c:2279: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x26 ] = KEY_RECORD,':
> linux/drivers/media/common/ir-keymaps.c:2279: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x06 ] = KEY_PLAY,':
> linux/drivers/media/common/ir-keymaps.c:2280: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x06 ] = KEY_PLAY,':
> linux/drivers/media/common/ir-keymaps.c:2280: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x36 ] = KEY_STOP,':
> linux/drivers/media/common/ir-keymaps.c:2281: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x36 ] = KEY_STOP,':
> linux/drivers/media/common/ir-keymaps.c:2281: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x16 ] = KEY_PAUSE,':
> linux/drivers/media/common/ir-keymaps.c:2282: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x16 ] = KEY_PAUSE,':
> linux/drivers/media/common/ir-keymaps.c:2282: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2e ] = KEY_REWIND,':
> linux/drivers/media/common/ir-keymaps.c:2283: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2e ] = KEY_REWIND,':
> linux/drivers/media/common/ir-keymaps.c:2283: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0e ] = KEY_FASTFORWARD,':
> linux/drivers/media/common/ir-keymaps.c:2284: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0e ] = KEY_FASTFORWARD,':
> linux/drivers/media/common/ir-keymaps.c:2284: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x30 ] = KEY_TEXT,':
> linux/drivers/media/common/ir-keymaps.c:2285: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x30 ] = KEY_TEXT,':
> linux/drivers/media/common/ir-keymaps.c:2285: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x21 ] = KEY_GREEN,':
> linux/drivers/media/common/ir-keymaps.c:2286: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x21 ] = KEY_GREEN,':
> linux/drivers/media/common/ir-keymaps.c:2286: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x01 ] = KEY_BLUE,':
> linux/drivers/media/common/ir-keymaps.c:2287: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x01 ] = KEY_BLUE,':
> linux/drivers/media/common/ir-keymaps.c:2287: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x08 ] = KEY_EPG,':
> linux/drivers/media/common/ir-keymaps.c:2288: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x08 ] = KEY_EPG,':
> linux/drivers/media/common/ir-keymaps.c:2288: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2a ] = KEY_MENU,':
> linux/drivers/media/common/ir-keymaps.c:2289: ERROR: space prohibited after that open square bracket '['
> linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2a ] = KEY_MENU,':
> linux/drivers/media/common/ir-keymaps.c:2289: ERROR: space prohibited before that close square bracket ']'
> linux/drivers/media/common/ir-keymaps.c: In 'EXPORT_SYMBOL_GPL(ir_codes_avermedia_a16d);':
> linux/drivers/media/common/ir-keymaps.c:2292: warning: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> linux/drivers/media/video/saa7134/saa7134-cards.c: In '^I^Icase SAA7134_BOARD_AVERMEDIA_A16D:^I$':
> linux/drivers/media/video/saa7134/saa7134-cards.c:5514: ERROR: trailing whitespace
> linux/drivers/media/video/saa7134/saa7134-cards.c: In '  ^I        dev->has_remote = SAA7134_REMOTE_GPIO;^I^I$':
> linux/drivers/media/video/saa7134/saa7134-cards.c:5752: ERROR: trailing whitespace
> linux/drivers/media/video/saa7134/saa7134-cards.c: In '  ^I        dev->has_remote = SAA7134_REMOTE_GPIO;^I^I$':
> linux/drivers/media/video/saa7134/saa7134-cards.c:5752: ERROR: code indent should use tabs where possible
> linux/drivers/media/video/saa7134/saa7134-dvb.c: In '^I$':
> linux/drivers/media/video/saa7134/saa7134-dvb.c:163: ERROR: trailing whitespace
> linux/drivers/media/video/saa7134/saa7134-dvb.c: In '		dev->dvb.frontend = dvb_attach(mt352_attach, &avermedia_xc3028_mt352_dev,':
> linux/drivers/media/video/saa7134/saa7134-dvb.c:972: warning: line over 80 characters
> linux/drivers/media/video/saa7134/saa7134-dvb.c: In '		dev->dvb.frontend = dvb_attach(mt352_attach,&avermedia_xc3028_mt352_dev,':
> linux/drivers/media/video/saa7134/saa7134-dvb.c:1261: warning: line over 80 characters
> linux/drivers/media/video/saa7134/saa7134-dvb.c: In '		dev->dvb.frontend = dvb_attach(mt352_attach,&avermedia_xc3028_mt352_dev,':
> linux/drivers/media/video/saa7134/saa7134-dvb.c:1261: ERROR: space required after that ',' (ctx:VxO)
> linux/drivers/media/video/saa7134/saa7134-dvb.c: In '		dev->dvb.frontend = dvb_attach(mt352_attach,&avermedia_xc3028_mt352_dev,':
> linux/drivers/media/video/saa7134/saa7134-dvb.c:1261: ERROR: space required before that '&' (ctx:OxV)
> linux/drivers/media/video/saa7134/saa7134-input.c: In '		polling      = 50; // ms':
> linux/drivers/media/video/saa7134/saa7134-input.c:330: ERROR: do not use C99 // comments
>
>
> Cheers,
> Mauro
>
>   
Invisible whitespaces! Grrr!

timf@ubuntu:~/1/try2$ diff -upr v4l-dvb v4l-dvb-tim > tim.patch
timf@ubuntu:~/1/try2$ cd v4l-dvb-tim
timf@ubuntu:~/1/try2/v4l-dvb-tim$ make checkpatch
make -C /home/timf/1/try2/v4l-dvb-tim/v4l checkpatch
make[1]: Entering directory `/home/timf/1/try2/v4l-dvb-tim/v4l'
scripts/check.pl -c
# WARNING: /lib/modules/`uname -r`/build/scripts/checkpatch.pl version 
0.12 is
#         older than scripts/checkpatch.pl --no-tree version 0.16.
#          Using in-tree one.
#
make[1]: Leaving directory `/home/timf/1/try2/v4l-dvb-tim/v4l'
timf@ubuntu:~/1/try2/v4l-dvb-tim$

My confidence is shot to pieces, you realise!

Attached - tim.patch

Please, please work!

Regards,
Timf

--------------040201040100090908070606
Content-Type: text/x-diff;
 name="tim.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tim.patch"

Binary files v4l-dvb/.hg/dirstate and v4l-dvb-tim/.hg/dirstate differ
diff -upr v4l-dvb/linux/drivers/media/common/ir-keymaps.c v4l-dvb-tim/linux/drivers/media/common/ir-keymaps.c
--- v4l-dvb/linux/drivers/media/common/ir-keymaps.c	2008-06-15 21:04:39.000000000 +0800
+++ v4l-dvb-tim/linux/drivers/media/common/ir-keymaps.c	2008-06-15 21:04:12.000000000 +0800
@@ -2251,3 +2251,42 @@ IR_KEYTAB_TYPE ir_codes_powercolor_real_
 	[0x25] = KEY_POWER,		/* power */
 };
 EXPORT_SYMBOL_GPL(ir_codes_powercolor_real_angel);
+
+IR_KEYTAB_TYPE ir_codes_avermedia_a16d[IR_KEYTAB_SIZE] = {
+	[0x20] = KEY_LIST,
+	[0x00] = KEY_POWER,
+	[0x28] = KEY_1,
+	[0x18] = KEY_2,
+	[0x38] = KEY_3,
+	[0x24] = KEY_4,
+	[0x14] = KEY_5,
+	[0x34] = KEY_6,
+	[0x2c] = KEY_7,
+	[0x1c] = KEY_8,
+	[0x3c] = KEY_9,
+	[0x12] = KEY_SUBTITLE,
+	[0x22] = KEY_0,
+	[0x32] = KEY_REWIND,
+	[0x3a] = KEY_SHUFFLE,
+	[0x02] = KEY_PRINT,
+	[0x11] = KEY_CHANNELDOWN,
+	[0x31] = KEY_CHANNELUP,
+	[0x0c] = KEY_ZOOM,
+	[0x1e] = KEY_VOLUMEDOWN,
+	[0x3e] = KEY_VOLUMEUP,
+	[0x0a] = KEY_MUTE,
+	[0x04] = KEY_AUDIO,
+	[0x26] = KEY_RECORD,
+	[0x06] = KEY_PLAY,
+	[0x36] = KEY_STOP,
+	[0x16] = KEY_PAUSE,
+	[0x2e] = KEY_REWIND,
+	[0x0e] = KEY_FASTFORWARD,
+	[0x30] = KEY_TEXT,
+	[0x21] = KEY_GREEN,
+	[0x01] = KEY_BLUE,
+	[0x08] = KEY_EPG,
+	[0x2a] = KEY_MENU,
+};
+EXPORT_SYMBOL_GPL(ir_codes_avermedia_a16d);
+
diff -upr v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c v4l-dvb-tim/linux/drivers/media/video/saa7134/saa7134-cards.c
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2008-06-15 21:04:39.000000000 +0800
+++ v4l-dvb-tim/linux/drivers/media/video/saa7134/saa7134-cards.c	2008-06-15 21:15:32.000000000 +0800
@@ -4232,11 +4232,7 @@ struct saa7134_board saa7134_boards[] = 
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		 /*
-		    TODO:
 		 .mpeg           = SAA7134_MPEG_DVB,
-		 */
-
 		 .inputs         = {{
 			 .name = name_tv,
 			 .vmux = 1,
@@ -4263,10 +4259,7 @@ struct saa7134_board saa7134_boards[] = 
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-#if 0
-		/* Not working yet */
 		.mpeg           = SAA7134_MPEG_DVB,
-#endif
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -4279,7 +4272,7 @@ struct saa7134_board saa7134_boards[] = 
 		} },
 		.radio = {
 			.name = name_radio,
-			.amux = LINE1,
+			.amux = TV,
 		},
 	},
 	[SAA7134_BOARD_AVERMEDIA_M115] = {
@@ -5510,22 +5503,21 @@ static int saa7134_xc2028_callback(struc
 {
 	switch (command) {
 	case XC2028_TUNER_RESET:
-		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0x06e20000);
-		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0x06a20000);
-		mdelay(250);
-		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0);
-		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0);
-		mdelay(250);
-		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x06e20000, 0x06e20000);
-		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x06a20000, 0x06a20000);
-		mdelay(250);
-		saa_andorl(SAA7133_ANALOG_IO_SELECT >> 2, 0x02, 0x02);
-		saa_andorl(SAA7134_ANALOG_IN_CTRL1 >> 2, 0x81, 0x81);
-		saa_andorl(SAA7134_AUDIO_CLOCK0 >> 2, 0x03187de7, 0x03187de7);
-		saa_andorl(SAA7134_AUDIO_PLL_CTRL >> 2, 0x03, 0x03);
-		saa_andorl(SAA7134_AUDIO_CLOCKS_PER_FIELD0 >> 2,
-			   0x0001e000, 0x0001e000);
-		return 0;
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00000000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+		switch (dev->board) {
+		case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
+			saa7134_set_gpio(dev, 23, 0);
+			msleep(10);
+			saa7134_set_gpio(dev, 23, 1);
+		break;
+		case SAA7134_BOARD_AVERMEDIA_A16D:
+			saa7134_set_gpio(dev, 21, 0);
+			msleep(10);
+			saa7134_set_gpio(dev, 21, 1);
+		break;
+		}
+	return 0;
 	}
 	return -EINVAL;
 }
@@ -5735,9 +5727,7 @@ int saa7134_board_init1(struct saa7134_d
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x08000000, 0x00000000);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS:
-	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 	case SAA7134_BOARD_AVERMEDIA_M115:
-	case SAA7134_BOARD_AVERMEDIA_A16D:
 #if 1
 		/* power-down tuner chip */
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0);
@@ -5749,6 +5739,18 @@ int saa7134_board_init1(struct saa7134_d
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0xffffffff);
 		msleep(10);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
+		saa7134_set_gpio(dev, 23, 0);
+		msleep(10);
+		saa7134_set_gpio(dev, 23, 1);
+		break;
+	case SAA7134_BOARD_AVERMEDIA_A16D:
+		saa7134_set_gpio(dev, 21, 0);
+		msleep(10);
+		saa7134_set_gpio(dev, 21, 1);
+		msleep(1);
+		dev->has_remote = SAA7134_REMOTE_GPIO;
+		break;
 	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
 #if 1
 		/* power-down tuner chip */
@@ -5864,6 +5866,7 @@ static void saa7134_tuner_setup(struct s
 
 		switch (dev->board) {
 		case SAA7134_BOARD_AVERMEDIA_A16D:
+		case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 			ctl.demod = XC3028_FE_ZARLINK456;
 			break;
 		default:
diff -upr v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c v4l-dvb-tim/linux/drivers/media/video/saa7134/saa7134-dvb.c
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c	2008-06-15 21:04:39.000000000 +0800
+++ v4l-dvb-tim/linux/drivers/media/video/saa7134/saa7134-dvb.c	2008-06-15 21:04:12.000000000 +0800
@@ -153,12 +153,12 @@ static int mt352_aver777_init(struct dvb
 	return 0;
 }
 
-static int mt352_aver_a16d_init(struct dvb_frontend *fe)
+static int mt352_avermedia_xc3028_init(struct dvb_frontend *fe)
 {
-	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x2d };
-	static u8 reset []         = { RESET,      0x80 };
-	static u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
-	static u8 agc_cfg []       = { AGC_TARGET, 0x28, 0xa0 };
+	static u8 clock_config []  = { CLOCK_CTL, 0x38, 0x2d };
+	static u8 reset []         = { RESET, 0x80 };
+	static u8 adc_ctl_1_cfg [] = { ADC_CTL_1, 0x40 };
+	static u8 agc_cfg []       = { AGC_TARGET, 0xe };
 	static u8 capt_range_cfg[] = { CAPT_RANGE, 0x33 };
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
@@ -167,12 +167,9 @@ static int mt352_aver_a16d_init(struct d
 	mt352_write(fe, adc_ctl_1_cfg,  sizeof(adc_ctl_1_cfg));
 	mt352_write(fe, agc_cfg,        sizeof(agc_cfg));
 	mt352_write(fe, capt_range_cfg, sizeof(capt_range_cfg));
-
 	return 0;
 }
 
-
-
 static int mt352_pinnacle_tuner_set_params(struct dvb_frontend* fe,
 					   struct dvb_frontend_parameters* params)
 {
@@ -215,17 +212,10 @@ static struct mt352_config avermedia_777
 	.demod_init    = mt352_aver777_init,
 };
 
-static struct mt352_config avermedia_16d = {
-	.demod_address = 0xf,
-	.demod_init    = mt352_aver_a16d_init,
-};
-
-static struct mt352_config avermedia_e506r_mt352_dev = {
+static struct mt352_config avermedia_xc3028_mt352_dev = {
 	.demod_address   = (0x1e >> 1),
-#if 0
-	.input_frequency = 0x31b8,
-#endif
 	.no_tuner        = 1,
+	.demod_init      = mt352_avermedia_xc3028_init,
 };
 
 /* ==================================================================
@@ -978,9 +968,10 @@ static int dvb_init(struct saa7134_dev *
 		}
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A16D:
-		dprintk("avertv A16D dvb setup\n");
-		dev->dvb.frontend = dvb_attach(mt352_attach, &avermedia_16d,
-					       &dev->i2c_adap);
+		dprintk("AverMedia A16D dvb setup\n");
+		dev->dvb.frontend = dvb_attach(mt352_attach,
+						&avermedia_xc3028_mt352_dev,
+						&dev->i2c_adap);
 		attach_xc3028 = 1;
 		break;
 	case SAA7134_BOARD_MD7134:
@@ -1264,15 +1255,18 @@ static int dvb_init(struct saa7134_dev *
 			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
+		dprintk("AverMedia E506R dvb setup\n");
+		saa7134_set_gpio(dev, 25, 0);
+		msleep(10);
+		saa7134_set_gpio(dev, 25, 1);
+		dev->dvb.frontend = dvb_attach(mt352_attach,
+						&avermedia_xc3028_mt352_dev,
+						&dev->i2c_adap);
+		attach_xc3028 = 1;
 #if 0
 	/*FIXME: What frontend does Videomate T750 use? */
 	case SAA7134_BOARD_VIDEOMATE_T750:
 #endif
-		dev->dvb.frontend = dvb_attach(mt352_attach,
-					       &avermedia_e506r_mt352_dev,
-					       &dev->i2c_adap);
-		attach_xc3028 = 1;
-		break;
 	case SAA7134_BOARD_MD7134_BRIDGE_2:
 		dev->dvb.frontend = dvb_attach(tda10086_attach,
 						&sd1878_4m, &dev->i2c_adap);
diff -upr v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c v4l-dvb-tim/linux/drivers/media/video/saa7134/saa7134-input.c
--- v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2008-06-15 21:04:39.000000000 +0800
+++ v4l-dvb-tim/linux/drivers/media/video/saa7134/saa7134-input.c	2008-06-15 21:04:12.000000000 +0800
@@ -323,6 +323,15 @@ int saa7134_input_init1(struct saa7134_d
 		saa_setb(SAA7134_GPIO_GPMODE1, 0x1);
 		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A16D:
+		ir_codes     = ir_codes_avermedia_a16d;
+		mask_keycode = 0x02F200;
+		mask_keydown = 0x000400;
+		polling      = 50; /* ms */
+		/* Without this we won't receive key up events */
+		saa_setb(SAA7134_GPIO_GPMODE1, 0x1);
+		saa_setb(SAA7134_GPIO_GPSTATUS1, 0x1);
+		break;
 	case SAA7134_BOARD_KWORLD_TERMINATOR:
 		ir_codes     = ir_codes_pixelview;
 		mask_keycode = 0x00001f;
diff -upr v4l-dvb/linux/include/media/ir-common.h v4l-dvb-tim/linux/include/media/ir-common.h
--- v4l-dvb/linux/include/media/ir-common.h	2008-06-15 21:04:39.000000000 +0800
+++ v4l-dvb-tim/linux/include/media/ir-common.h	2008-06-15 21:04:12.000000000 +0800
@@ -146,6 +146,7 @@ extern IR_KEYTAB_TYPE ir_codes_behold_co
 extern IR_KEYTAB_TYPE ir_codes_pinnacle_pctv_hd[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_genius_tvgo_a11mce[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_powercolor_real_angel[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_avermedia_a16d[IR_KEYTAB_SIZE];
 
 #endif
 
Only in v4l-dvb-tim/v4l: .config
Only in v4l-dvb-tim/v4l: Kconfig
Only in v4l-dvb-tim/v4l: .kconfig.dep
Only in v4l-dvb-tim/v4l: Kconfig.kern
Only in v4l-dvb-tim/v4l: Makefile.media
Only in v4l-dvb-tim/v4l: .myconfig
Only in v4l-dvb-tim/v4l: .version

--------------040201040100090908070606
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------040201040100090908070606--
