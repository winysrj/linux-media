Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s21.blu0.hotmail.com ([65.55.111.96]:16934 "EHLO
	blu0-omc2-s21.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbaANFRl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 00:17:41 -0500
Message-ID: <BLU0-SMTP183F0EEECCB365900DE2315ADBF0@phx.gbl>
Date: Tue, 14 Jan 2014 13:17:45 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Andrzej Hajda <a.hajda@samsung.com>
CC: kyungmin.park@samsung.com
Subject: Re: using MFC memory to memery encoder, start stream and queue order
 problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl> <02c701cf07b6$565cd340$031679c0$%debski@samsung.com> <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl> <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com> <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl> <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com> <52CD725E.5060903@hotmail.com> <BLU0-SMTP6650E76A95FA2BB39C6325ADB30@phx.gbl> <52CFD5DF.6050801@samsung.com> <BLU0-SMTP37B0A51F0A2D2F1E79A730ADB30@phx.gbl> <52D3BCB7.1060309@samsung.com> <52D3CB84.6090406@samsung.com> <BLU0-SMTP3546CDA7E88F73435A3A876ADBC0@phx.gbl> <001701cf107b$0927aa50$1b76fef0$%debski@samsung.com>
In-Reply-To: <001701cf107b$0927aa50$1b76fef0$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2014年01月14日 00:18, Kamil Debski 写道:
> Hi,
> 
>> From: randy [mailto:lxr1234@hotmail.com]
>> Sent: Monday, January 13, 2014 4:45 PM
>>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>>  20140113 19:18, Andrzej Hajda wrote:
>>
>>>>>>>>> It won't work, if I do that, after step 7, neither OUPUT nor
>>>>>>>>> CAPTURE will poll return in my program. but ./mfc-encode -m
>>>>>>>>> /dev/video1 -c h264,header_mode=1 work normally,
>>>>>>>> I am sorry, I didn't well test it, if I use ./mfc-encode -m
>>>>>>>> /dev/video1 -c h264,header_mode=1 -d 1 then the size of demo.out
>>>>>>>> is zero, but ./mfc-encode -d 1 -m /dev/video1 -c h264 will out a
>>>>>>>> 158 bytes files. When duration is 2, with header_mode=1, the
>>>>>>>> output file size is 228 bytes.Without it, the size is 228 too. I
>>>>>>>> wonder whether it is the driver's problem, as I see this in
>> dmesg
>>>>>>>> [ 0.210000] Failed to declare coherent memory for MFC device (0
>>>>>>>> bytes at 0x43000000) As the driver is not ready to use in
>>>>>>>> 3.13-rc6 as I reported before, I still use the
>>>>>>>> 3.5 from manufacturer.
>>>>>>>
>>>>>>> I am the author of mfc-encode application, it was written for the
>>>>>>> mainline kernel 3.8 and later, it should be mentioned in the
>>>>>>> README.txt - I will update it.
>> So it seems that the design my program is correct, just the driver's
>> problem?
>>
>>>>>>>
>>> Sadness, they doesn't offer any of them, even not any information
>>> about it. And I can't compile the openmax from samsung. I will report
>>> it later in sourceforge.
>>>>>
>>>
>>>> I believe it is the best solution if you are interesting in fixing
>>>> only MFC encoding. If your goal is wider I suggest to try linux-next
>>>> kernel. There is basic(!) DT support for this board applied about
>>>> month ago: https://lkml.org/lkml/2013/12/18/285
>>>
>> I will try it, I wish the driver in -next is done, as I can never open
>> the mfc encoder in 3.12.
> 
> Randy, 
> 
> Please apply these two patches:
> [PATCH] media: s5p_mfc: remove s5p_mfc_get_node_type() function
> [PATCH] media: v4l2-dev: fix video device index assignment
> 
> And try again with kernel 3.12. There was a problem with opening MFC
> that was introduced by other patches.
> 
Yes, it make encoder work. But sadness ./mfc-encode -m /dev/video1 -c
h264,header_mode=1 -d 1 will still output a zero demo.out without
header-mode or set it to zero will works.
What is the problem?
>> I have another problem with the data transporting way in v4l2-mfc-
>> encoder, it use m.userptr, I think it is not need, as it has been mmap
>> to bufs->addr before, just fill the bufs->addr is enough, and for mfc,
>> the buffer type V4L2_MEMORY_MMAP,  I think that it had better use
>> m.mem_offset from v4l2 document, why it use userptr?
>>
> 
> Best wishes,

