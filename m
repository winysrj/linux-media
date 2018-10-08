Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59050 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726348AbeJIBoR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 21:44:17 -0400
Subject: Re: [PATCH] media: vivid: Support 480p for webcam capture
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, tfiga@chromium.org,
        jcliang@chromium.org, shik@chromium.org
References: <20181003070656.193854-1-keiichiw@chromium.org>
 <b2dc51d7-fc92-2e7b-3a07-55a076b95d8b@ideasonboard.com>
 <20181008140302.2239633f@coco.lan>
 <00b0a8af-b7a5-cb49-0684-0fd0efefa196@xs4all.nl>
 <20181008152348.7ef6d77e@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <931ca67d-3ac6-afc1-f933-c9733d561767@xs4all.nl>
Date: Mon, 8 Oct 2018 20:31:10 +0200
MIME-Version: 1.0
In-Reply-To: <20181008152348.7ef6d77e@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2018 08:23 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 8 Oct 2018 19:53:38 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 10/08/2018 07:03 PM, Mauro Carvalho Chehab wrote:
>>> Em Wed, 3 Oct 2018 12:14:22 +0100
>>> Kieran Bingham <kieran.bingham@ideasonboard.com> escreveu:
>>>   
>>>>> @@ -75,6 +76,8 @@ static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
>>>>>  	{  1, 5 },
>>>>>  	{  1, 10 },
>>>>>  	{  1, 15 },
>>>>> +	{  1, 15 },
>>>>> +	{  1, 25 },    
>>>
>>> As the code requires that VIVID_WEBCAM_IVALS would be twice the number
>>> of resolutions, I understand why you're doing that.
>>>   
>>>> But won't this add duplicates of 25 and 15 FPS to all the frame sizes
>>>> smaller than 1280,720 ? Or are they filtered out?  
>>>
>>> However, I agree with Kieran: looking at the code, it sounds to me that
>>> it will indeed duplicate 1/15 and 1/25 intervals.  
>>
>> Oops, I missed this comment. Yes, you'll get duplicates which should be
>> avoided.
>>
>>>
>>> I suggest add two other intervals there, like:
>>> 	12.5 fps and 29.995 fps, e. g.:  
>>
>> 29.995 is never used by webcams.
>>
>>>
>>> static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
>>>         {  1, 1 },
>>>         {  1, 2 },
>>>         {  1, 4 },
>>>         {  1, 5 },
>>>         {  1, 10 },
>>>         {  1, 15 },
>>> 	{  2, 50 },
>>>         {  1, 25 },
>>>         {  1, 30 },
>>>         {  1, 40 },
>>>         {  1, 50 },
>>> 	{  1001, 30000 },
>>>         {  1, 60 },
>>> };
>>>
>>> Provided, of course, that vivid would support producing images
>>> at fractional rate. I didn't check. If not, then simply add
>>> 1/20 and 1/40.  
>>
>> vivid can do fractional rates (it does support this for the TV input),
>> but 29.995 makes no sense for a webcam. 
> 
> Yes, I know.
> 
>> So 1/20 and 1/40 seems the
>> right approach.
> 
> I would have 1/12.5 at least. I have some webcams here whose seem to
> use things like that under bad light, and it sounds interesting to
> have at least one fraction that doesn't start with "1", in order to
> be sure that camera apps are doing the right thing.
> 
>>>> Now the difficulty is adding smaller frame rates (like 1,1, 1,2) would
>>>> effect/reduce the output rates of the larger frame sizes, so how about
>>>> adding some high rate support (any two from 1/{60,75,90,100,120}) instead?  
>>>
>>> Last week, I got a crash with vivid running at 30 fps, while running an 
>>> event's race code, on a i7core (there, the code was switching all video
>>> controls while subscribing/unsubscribing events). The same code worked
>>> with lower fps.  
>>
>> If you have a stack trace, then let me know.
> 
> See at the end.
> 
> I intend to do further tests when I have some time.
> 
>>
>>> While I didn't have time to debug it yet, I suspect that it has to do
>>> with the time spent to produce a frame on vivid. So, while it would be
>>> nice to have high rate support, I'm not sure if this is doable. It may,
>>> but perhaps we need to disable some possible video output formats, as some
>>> types may consume more time to build frames.  
>>
>> In the end that depends on the CPU and what else is running. You'll know quickly
>> enough if the CPU isn't fast enough to support a format. Although it shouldn't
>> crash, of course.
> 
> Yes, but on this case, it caused an OOPS (with KASAN enabled).
> 
> I was running the stress test on one VT while using qv4l2 to stream.
> 
> When I changed the resolution, it caused the OOPS.
> 
> This is one example.
> 
> I ran the race test first. It placed all controls at some random state
> (only issued VIDIOC_EXT_CTRLS - kept everything else on default).
> 
> when asked qv4l2 to start streaming (5fps), got this:
> 
> 
> [348569.866967] BUG: unable to handle kernel paging request at ffffc90303ff73b5
> [348569.867070] PGD 406ee8067 P4D 406ee8067 PUD 0 
> [348569.867081] Oops: 0002 [#1] SMP KASAN
> [348569.867089] CPU: 2 PID: 4365 Comm: vivid-000-vid-c Tainted: G    B             4.19.0-rc1+ #3
> [348569.867098] Hardware name:  /NUC5i7RYB, BIOS RYBDWi35.86A.0364.2017.0511.0949 05/11/2017
> [348569.867113] RIP: 0010:tpg_print_str_6+0x241/0x960 [v4l2_tpg]
> [348569.867122] Code: 24 18 e9 a5 01 00 00 84 c9 0f 84 48 03 00 00 40 84 ed 48 8d 7b 15 be 02 00 00 00 0f 88 cb 06 00 00 e8 a3 cd 2f ec 48 8d 7b 17 <66> 44 89 73 15 e8 b5 c7
>  2f ec 44 88 6b 17 40 f6 c5 40 48 8d 7b 12
> [348569.867136] RSP: 0018:ffff88024b6cf8c8 EFLAGS: 00010246
> [348569.867144] RAX: fffff520607fee77 RBX: ffffc90303ff73a0 RCX: ffffffffc10c22cd
> [348569.867152] RDX: 0000000000000001 RSI: 0000000000000002 RDI: ffffc90303ff73b7
> [348569.867162] RBP: 0000000000000000 R08: fffff520607fee77 R09: fffff520607fee77
> [348569.867170] R10: 0000000000000001 R11: fffff520607fee76 R12: ffff88024b6cfcf1
> [348569.867179] R13: 0000000000000010 R14: 0000000000001010 R15: 00000000000000ea
> [348569.867189] FS:  0000000000000000(0000) GS:ffff880407300000(0000) knlGS:0000000000000000
> [348569.867198] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [348569.867206] CR2: ffffc90303ff73b5 CR3: 0000000346c0d004 CR4: 00000000003606e0
> [348569.867214] Call Trace:
> [348569.867227]  tpg_gen_text+0x258/0x2b0 [v4l2_tpg]
> [348569.867249]  vivid_fillbuff+0x1e9b/0x30b0 [vivid]
> [348569.867261]  ? __list_add_valid+0x29/0x90
> [348569.867271]  ? __switch_to+0x345/0x700
> [348569.867281]  ? osq_unlock+0x6b/0xf0
> [348569.867302]  ? vivid_grab_controls+0x60/0x60 [vivid]
> [348569.867312]  ? del_timer_sync+0x3e/0x50
> [348569.867320]  ? schedule_timeout+0x234/0x4e0
> [348569.867330]  ? mutex_lock+0xbd/0xc0
> [348569.867337]  ? mutex_lock+0xbd/0xc0
> [348569.867345]  ? __mutex_lock_slowpath+0x10/0x10
> [348569.867365]  ? vivid_thread_vid_cap+0x5b6/0xf20 [vivid]
> [348569.867385]  vivid_thread_vid_cap+0x5b6/0xf20 [vivid]
> [348569.867396]  ? __sched_text_start+0x8/0x8
> [348569.867404]  ? __wake_up_common+0x9c/0x230
> [348569.867413]  ? __kthread_parkme+0x77/0x90
> [348569.867432]  ? vivid_fillbuff+0x30b0/0x30b0 [vivid]
> [348569.867440]  kthread+0x1ac/0x1d0
> [348569.867448]  ? kthread_create_worker_on_cpu+0xc0/0xc0
> [348569.867458]  ret_from_fork+0x1f/0x30
> [348569.867465] Modules linked in: vivid videobuf2_dma_contig v4l2_tpg v4l2_dv_timings videobuf2_v4l2 videobuf2_vmalloc videobuf2_memops videobuf2_common v4l2_common videode
> v media xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c tun bridge stp llc ebtable
> _filter ebtables ip6table_filter ip6_tables bluetooth rfkill ecdh_generic snd_hda_codec_hdmi i915 snd_hda_intel snd_usb_audio snd_hda_codec intel_rapl snd_usbmidi_lib x86_pk
> g_temp_thermal snd_hda_core i2c_algo_bit snd_hwdep intel_powerclamp coretemp snd_pcm snd_seq_midi drm_kms_helper crct10dif_pclmul snd_seq_midi_event crc32_pclmul snd_rawmidi
>  ghash_clmulni_intel intel_cstate snd_seq intel_uncore drm intel_rapl_perf snd_seq_device snd_timer e1000e snd ptp mei_me
> [348569.867574]  video mei soundcore pps_core lpc_ich fuse binfmt_misc kvm_intel kvm irqbypass crc32c_intel [last unloaded: videobuf2_memops]
> [348569.867597] CR2: ffffc90303ff73b5
> [348569.867604] ---[ end trace b85f80398f88914d ]---
> [348569.867615] RIP: 0010:tpg_print_str_6+0x241/0x960 [v4l2_tpg]
> [348569.867624] Code: 24 18 e9 a5 01 00 00 84 c9 0f 84 48 03 00 00 40 84 ed 48 8d 7b 15 be 02 00 00 00 0f 88 cb 06 00 00 e8 a3 cd 2f ec 48 8d 7b 17 <66> 44 89 73 15 e8 b5 c7
>  2f ec 44 88 6b 17 40 f6 c5 40 48 8d 7b 12
> [348569.867639] RSP: 0018:ffff88024b6cf8c8 EFLAGS: 00010246
> [348569.867647] RAX: fffff520607fee77 RBX: ffffc90303ff73a0 RCX: ffffffffc10c22cd
> [348569.867656] RDX: 0000000000000001 RSI: 0000000000000002 RDI: ffffc90303ff73b7
> [348569.867665] RBP: 0000000000000000 R08: fffff520607fee77 R09: fffff520607fee77
> [348569.867674] R10: 0000000000000001 R11: fffff520607fee76 R12: ffff88024b6cfcf1
> [348569.867682] R13: 0000000000000010 R14: 0000000000001010 R15: 00000000000000ea
> [348569.867692] FS:  0000000000000000(0000) GS:ffff880407300000(0000) knlGS:0000000000000000
> [348569.867701] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [348569.867709] CR2: ffffc90303ff73b5 CR3: 0000000346c0d004 CR4: 00000000003606e0
> 
> 
> (gdb) list *vivid_fillbuff+0x1e9b
> 0x1936b is in vivid_fillbuff (drivers/media/platform/vivid/vivid-kthread-cap.c:495).
> 490					ms % 1000,
> 491					buf->vb.sequence,
> 492					(dev->field_cap == V4L2_FIELD_ALTERNATE) ?
> 493						(buf->vb.field == V4L2_FIELD_TOP ?
> 494						 " top" : " bottom") : "");
> 495			tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
> 496		}
> 497		if (dev->osd_mode == 0) {
> 498			snprintf(str, sizeof(str), " %dx%d, input %d ",
> 499					dev->src_rect.width, dev->src_rect.height, dev->input);
> 

There is a bug with hflip handling in that function. Nothing to do with the
resolution. I could reproduce it by just checking the hflip control.
I'll investigate.

Regards,

	Hans
