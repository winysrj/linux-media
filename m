Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAIKiK2c006848
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 15:44:20 -0500
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAIKiAp6021387
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 15:44:10 -0500
Received: by rn-out-0910.google.com with SMTP id k32so2828525rnd.7
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 12:44:10 -0800 (PST)
Message-ID: <ea3b75ed0811181244p713c7246ga06d91eceb7c56ad@mail.gmail.com>
Date: Tue, 18 Nov 2008 15:44:09 -0500
From: "Brian Phelps" <lm317t@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <ea3b75ed0811181010k3287581ew612a98ddf7a53ef6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ea3b75ed0811180953g4846fc80lf9d0018703486838@mail.gmail.com>
	<ea3b75ed0811181010k3287581ew612a98ddf7a53ef6@mail.gmail.com>
Subject: Re: Pre-crash log
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

Anyone know what this means?
[  768.998408] swap_dup: Bad swap file entry 4080000000101010
[  768.998418] VM: killing process monitor
[  768.998730] swap_free: Bad swap file entry 4080000000101010

<1 capture process died>

On Tue, Nov 18, 2008 at 1:10 PM, Brian Phelps <lm317t@gmail.com> wrote:
> I know 8 feeds of 640*480 @ 30fps is pushing it to the limits on the
> pci bus, but this shouldn't cause the system to crash should it?
>
> On Tue, Nov 18, 2008 at 12:53 PM, Brian Phelps <lm317t@gmail.com> wrote:
>> Hi all,
>> I am using the capture example on a quad core machine with kernel 2.6.27.6
>>
>> I added another 4 input card to see if that might decrease stability
>> and create some errors, and it did:
>>
>> [  566.820822] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.820934] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.824338] bttv2: next set: top=ffff8800120e0800
>> bottom=ffff8800120e0800 [screen=0000000000000000,irq=1,0]
>> [  566.824411] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.824555] bttv2: next set: top=ffff8800120e0a00
>> bottom=ffff8800120e0a00 [screen=0000000000000000,irq=1,0]
>> [  566.825539] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.825577] bttv1: next set: top=ffff880010499600
>> bottom=ffff880010499600 [screen=0000000000000000,irq=1,0]
>> [  566.825582] bttv5: next set: top=ffff8800189ea800
>> bottom=ffff8800189ea800 [screen=0000000000000000,irq=1,0]
>> [  566.825666] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.825676] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.825738] bttv2: OCERR @ 1a937000,bits: HSYNC FDSR OCERR*
>> [  566.825749]   main: 1a937000
>> [  566.825751]   vbi : o=00000000 e=00000000
>> [  566.825752]   cap : o=1a734000 e=1a736000
>> [  566.825754]   scr : o=00000000 e=00000000
>> [  566.825755] bttv2: risc disasm: ffff88001a937000 [dma=0x1a937000]
>> [  566.825757] bttv2:   0x1a937000: 0x80008004 [ sync be3/resync count=4 ]
>> [  566.825761] bttv2:   0x1a937004: 0x00000000 [ arg #1 ]
>> [  566.825762] bttv2:   0x1a937008: 0x70000000 [ jump count=0 ]
>> [  566.825765] bttv2:   0x1a93700c: 0x1a937010 [ arg #1 ]
>> [  566.825766] bttv2:   0x1a937010: 0x70000000 [ jump count=0 ]
>> [  566.825769] bttv2:   0x1a937014: 0x1a937018 [ arg #1 ]
>> [  566.825770] bttv2:   0x1a937018: 0x70000000 [ jump count=0 ]
>> [  566.825772] bttv2:   0x1a93701c: 0x1a734000 [ arg #1 ]
>> [  566.825774] bttv2:   0x1a937020: 0x8000800c [ sync be3/resync count=12 ]
>> [  566.825777] bttv2:   0x1a937024: 0x00000000 [ arg #1 ]
>> [  566.825778] bttv2:   0x1a937028: 0x70000000 [ jump count=0 ]
>> [  566.825781] bttv2:   0x1a93702c: 0x1a937030 [ arg #1 ]
>> [  566.825782] bttv2:   0x1a937030: 0x70000000 [ jump count=0 ]
>> [  566.825784] bttv2:   0x1a937034: 0x1a736000 [ arg #1 ]
>> [  566.825786] bttv2:   0x1a937038: 0x70000000 [ jump count=0 ]
>> [  566.825788] bttv2:   0x1a93703c: 0x1a937000 [ arg #1 ]
>> [  566.825789] bttv2:   0x1a937040: 0x00000000 [ INVALID count=0 ]
>> [  566.827594] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.827639] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.828306] bttv6: next set: top=ffff880010501400
>> bottom=ffff880010501400 [screen=0000000000000000,irq=1,0]
>> [  566.832424] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.834617] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.834987] bttv4: next set: top=ffff8800125a7200
>> bottom=ffff8800125a7200 [screen=0000000000000000,irq=1,0]
>> [  566.835086] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.836781] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.850350] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.851008] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.853023] bttv0: next set: top=ffff880010598c00
>> bottom=ffff880010598c00 [screen=0000000000000000,irq=1,0]
>> [  566.853027] bttv3: next set: top=ffff88001059cc00
>> bottom=ffff88001059cc00 [screen=0000000000000000,irq=1,0]
>> [  566.853101] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.853111] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.854760] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.854773] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.858940] bttv1: next set: top=ffff8800105d7600
>> bottom=ffff8800105d7600 [screen=0000000000000000,irq=1,0]
>> [  566.858959] bttv5: next set: top=ffff8800189eae00
>> bottom=ffff8800189eae00 [screen=0000000000000000,irq=1,0]
>> [  566.859079] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.860846] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.861678] bttv6: next set: top=ffff88001047ca00
>> bottom=ffff88001047ca00 [screen=0000000000000000,irq=1,0]
>> [  566.862357] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.864038] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.866056] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.868343] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.868363] bttv4: next set: top=ffff880010598e00
>> bottom=ffff880010598e00 [screen=0000000000000000,irq=1,0]
>> [  566.868607] BT878 video (ProVideo PV150): VIDIOC_DQBUF
>> [  566.870052] BT878 video (ProVideo PV150): VIDIOC_QBUF
>> [  566.880434] swap_free: Bad swap file entry 4000000000101010
>> [  566.886390] bttv0: next set: top=ffff880010598a00
>> bottom=ffff880010598a00 [screen=0000000000000000,irq=1,0]
>> [  566.886395] bttv3: next set: top=ffff8800125a4600
>> bottom=ffff8800125a4600 [screen=0000000000000000,irq=1,0]
>> [  566.891075] bttv2: next set: top=ffff8800105d4a00
>> bottom=ffff8800105d4a00 [screen=0000000000000000,irq=1,0]
>>
>> After the above, one of the processes dies:
>>
>> VIDIOC_DQBUF error 5, Input/output error
>>
>> Can someone tell me what I can do next? thanks!
>>
>> --
>> Brian Phelps
>> Got e- ?
>> http://electronjunkie.wordpress.com
>>
>
>
>
> --
> Brian Phelps
> Got e- ?
> http://electronjunkie.wordpress.com
>



-- 
Brian Phelps
Got e- ?
http://electronjunkie.wordpress.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
