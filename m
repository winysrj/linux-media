Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp27.orange.fr ([80.12.242.95]:5246 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbZIIJD1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2009 05:03:27 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2714.orange.fr (SMTP Server) with ESMTP id C0EA91C0008D
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 11:03:29 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2714.orange.fr (SMTP Server) with ESMTP id B1CB01C00097
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 11:03:29 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-19-82.w92-135.abo.wanadoo.fr [92.135.50.82])
	by mwinf2714.orange.fr (SMTP Server) with ESMTP id A6BBA1C0008D
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 11:03:28 +0200 (CEST)
Message-ID: <4AA76F5F.2070304@gmail.com>
Date: Wed, 09 Sep 2009 11:03:27 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com> <4AA695EE.70800@gmail.com> <4AA767F2.50702@gmail.com>
In-Reply-To: <4AA767F2.50702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i tried to load the saa7134 module with ir_debug=1 and removed all 
keycodes in ir-keymaps.c , here is what i got after pressing the buttons 
(left to right then going down on the remote ):
(power)
Sep  9 10:43:41 debian kernel: [ 3615.060015] saa7133[0]/ir: build_key 
gpio=0x1b mask=0x7f data=27
Sep  9 10:43:41 debian kernel: [ 3615.112017] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(mute)
Sep  9 10:43:44 debian kernel: [ 3618.440021] saa7133[0]/ir: build_key 
gpio=0x1f mask=0x7f data=31
Sep  9 10:43:44 debian kernel: [ 3618.492019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(1)
Sep  9 10:50:42 debian kernel: [ 4036.796017] saa7133[0]/ir: build_key 
gpio=0x17 mask=0x7f data=23
Sep  9 10:50:43 debian kernel: [ 4036.900019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(2)
Sep  9 10:51:14 debian kernel: [ 4068.776014] saa7133[0]/ir: build_key 
gpio=0xf mask=0x7f data=15
Sep  9 10:51:14 debian kernel: [ 4068.828017] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(3)
Sep  9 10:51:36 debian kernel: [ 4090.408016] saa7133[0]/ir: build_key 
gpio=0x13 mask=0x7f data=19
Sep  9 10:51:36 debian kernel: [ 4090.460020] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(4)
Sep  9 10:51:47 debian kernel: [ 4101.380016] saa7133[0]/ir: build_key 
gpio=0x16 mask=0x7f data=22
Sep  9 10:51:47 debian kernel: [ 4101.432019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(5)
Sep  9 10:52:00 debian kernel: [ 4114.068019] saa7133[0]/ir: build_key 
gpio=0xe mask=0x7f data=14
Sep  9 10:52:00 debian kernel: [ 4114.120020] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(6)
Sep  9 10:52:15 debian kernel: [ 4129.672020] saa7133[0]/ir: build_key 
gpio=0x1e mask=0x7f data=30
Sep  9 10:52:15 debian kernel: [ 4129.776019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(7)
Sep  9 10:52:34 debian kernel: [ 4148.132020] saa7133[0]/ir: build_key 
gpio=0x14 mask=0x7f data=20
Sep  9 10:52:34 debian kernel: [ 4148.236020] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(8)
Sep  9 10:52:49 debian kernel: [ 4163.160020] saa7133[0]/ir: build_key 
gpio=0xc mask=0x7f data=12
Sep  9 10:52:49 debian kernel: [ 4163.212022] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(9)
Sep  9 10:53:02 debian kernel: [ 4176.056016] saa7133[0]/ir: build_key 
gpio=0x1c mask=0x7f data=28
Sep  9 10:53:02 debian kernel: [ 4176.108017] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(jump)
Sep  9 10:48:56 debian kernel: [ 3930.144021] saa7133[0]/ir: build_key 
gpio=0x15 mask=0x7f data=21
Sep  9 10:48:56 debian kernel: [ 3930.196019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(0)
Sep  9 10:56:55 debian kernel: [ 4409.016020] saa7133[0]/ir: build_key 
gpio=0xd mask=0x7f data=13
Sep  9 10:56:55 debian kernel: [ 4409.068023] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(search)
Sep  9 10:57:05 debian kernel: [ 4419.520021] saa7133[0]/ir: build_key 
gpio=0x1d mask=0x7f data=29
Sep  9 10:57:05 debian kernel: [ 4419.624019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(guide)
Sep  9 10:57:14 debian kernel: [ 4428.568017] saa7133[0]/ir: build_key 
gpio=0x17 mask=0x7f data=23
Sep  9 10:57:14 debian kernel: [ 4428.620017] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(up arrow)
Sep  9 10:57:20 debian kernel: [ 4434.236015] saa7133[0]/ir: build_key 
gpio=0xf mask=0x7f data=15
Sep  9 10:57:20 debian kernel: [ 4434.340019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(menu)
Sep  9 10:57:29 debian kernel: [ 4443.180017] saa7133[0]/ir: build_key 
gpio=0x1f mask=0x7f data=31
Sep  9 10:57:29 debian kernel: [ 4443.232019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(left arrow)
Sep  9 10:57:41 debian kernel: [ 4455.504014] saa7133[0]/ir: build_key 
gpio=0x16 mask=0x7f data=22
Sep  9 10:57:41 debian kernel: [ 4455.556015] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(enter)
Sep  9 10:57:50 debian kernel: [ 4464.604018] saa7133[0]/ir: build_key 
gpio=0xe mask=0x7f data=14
Sep  9 10:57:50 debian kernel: [ 4464.656017] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(right arrow)
Sep  9 10:58:02 debian kernel: [ 4476.668018] saa7133[0]/ir: build_key 
gpio=0x1e mask=0x7f data=30
Sep  9 10:58:02 debian kernel: [ 4476.772019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(info)
Sep  9 10:58:12 debian kernel: [ 4485.976016] saa7133[0]/ir: build_key 
gpio=0x1a mask=0x7f data=26
Sep  9 10:58:12 debian kernel: [ 4486.028018] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(down arrow)
Sep  9 10:58:21 debian kernel: [ 4494.920015] saa7133[0]/ir: build_key 
gpio=0x6 mask=0x7f data=6
Sep  9 10:58:21 debian kernel: [ 4495.024019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(exit)
Sep  9 10:58:30 debian kernel: [ 4504.332020] saa7133[0]/ir: build_key 
gpio=0x12 mask=0x7f data=18
Sep  9 10:58:30 debian kernel: [ 4504.384020] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(previous)
Sep  9 10:58:44 debian kernel: [ 4518.788019] saa7133[0]/ir: build_key 
gpio=0x19 mask=0x7f data=25
Sep  9 10:58:45 debian kernel: [ 4518.892014] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(next)
Sep  9 10:58:51 debian kernel: [ 4525.604017] saa7133[0]/ir: build_key 
gpio=0x11 mask=0x7f data=17
Sep  9 10:58:51 debian kernel: [ 4525.656019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(rewind)
Sep  9 10:59:05 debian kernel: [ 4539.332015] saa7133[0]/ir: build_key 
gpio=0x18 mask=0x7f data=24
Sep  9 10:59:05 debian kernel: [ 4539.384016] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(play/pause)
Sep  9 10:59:15 debian kernel: [ 4549.836017] saa7133[0]/ir: build_key 
gpio=0x4 mask=0x7f data=4
Sep  9 10:59:16 debian kernel: [ 4549.940016] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127
(forward)
Sep  9 10:59:22 debian kernel: [ 4556.804014] saa7133[0]/ir: build_key 
gpio=0x10 mask=0x7f data=16
Sep  9 10:59:23 debian kernel: [ 4556.908021] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(record)
Sep  9 10:59:35 debian kernel: [ 4569.700019] saa7133[0]/ir: build_key 
gpio=0x1b mask=0x7f data=27
Sep  9 10:59:35 debian kernel: [ 4569.804016] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(stop)
Sep  9 10:59:44 debian kernel: [ 4578.124021] saa7133[0]/ir: build_key 
gpio=0x7 mask=0x7f data=7
Sep  9 10:59:44 debian kernel: [ 4578.176018] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(live)
Sep  9 10:59:52 debian kernel: [ 4586.288019] saa7133[0]/ir: build_key 
gpio=0x13 mask=0x7f data=19
Sep  9 10:59:52 debian kernel: [ 4586.340018] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(A)
Sep  9 11:00:02 debian kernel: [ 4596.792016] saa7133[0]/ir: build_key 
gpio=0xa mask=0x7f data=10
Sep  9 11:00:03 debian kernel: [ 4596.844018] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(dvd)
Sep  9 11:00:09 debian kernel: [ 4603.760020] saa7133[0]/ir: build_key 
gpio=0x6 mask=0x7f data=6
Sep  9 11:00:10 debian kernel: [ 4603.864026] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(B)
Sep  9 11:00:15 debian kernel: [ 4609.376018] saa7133[0]/ir: build_key 
gpio=0x12 mask=0x7f data=18
Sep  9 11:00:15 debian kernel: [ 4609.480019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(photo)
Sep  9 11:00:22 debian kernel: [ 4615.980021] saa7133[0]/ir: build_key 
gpio=0x8 mask=0x7f data=8
Sep  9 11:00:22 debian kernel: [ 4616.032021] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(video)
Sep  9 11:00:28 debian kernel: [ 4621.908019] saa7133[0]/ir: build_key 
gpio=0x0 mask=0x7f data=0
Sep  9 11:00:28 debian kernel: [ 4622.012018] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(music)
Sep  9 11:00:33 debian kernel: [ 4626.900016] saa7133[0]/ir: build_key 
gpio=0x19 mask=0x7f data=25
Sep  9 11:00:33 debian kernel: [ 4626.952019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(channel +)
Sep  9 11:00:51 debian kernel: [ 4645.464016] saa7133[0]/ir: build_key 
gpio=0xb mask=0x7f data=11
Sep  9 11:00:51 debian kernel: [ 4645.516016] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(prog 1)
Sep  9 11:00:58 debian kernel: [ 4652.068017] saa7133[0]/ir: build_key 
gpio=0x3 mask=0x7f data=3
Sep  9 11:00:58 debian kernel: [ 4652.172020] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(volume+)
Sep  9 11:01:05 debian kernel: [ 4659.036021] saa7133[0]/ir: build_key 
gpio=0x15 mask=0x7f data=21
Sep  9 11:01:05 debian kernel: [ 4659.088020] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(prog 2)
Sep  9 11:01:12 debian kernel: [ 4666.316023] saa7133[0]/ir: build_key 
gpio=0x1 mask=0x7f data=1
Sep  9 11:01:12 debian kernel: [ 4666.420019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(channel -)
Sep  9 11:01:20 debian kernel: [ 4674.324018] saa7133[0]/ir: build_key 
gpio=0x8 mask=0x7f data=8
Sep  9 11:01:20 debian kernel: [ 4674.376015] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(prog 3)
Sep  9 11:01:27 debian kernel: [ 4681.760016] saa7133[0]/ir: build_key 
gpio=0x0 mask=0x7f data=0
Sep  9 11:01:28 debian kernel: [ 4681.864020] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

(volume -)
Sep  9 11:01:36 debian kernel: [ 4690.496020] saa7133[0]/ir: build_key 
gpio=0x1c mask=0x7f data=28
Sep  9 11:01:36 debian kernel: [ 4690.548019] saa7133[0]/ir: build_key 
gpio=0x7f mask=0x7f data=127

i hopt someone can make sense of this.

Morvan Le Meut a écrit :
> Working on it, but i don't think everything is correct : some totaly 
> unrelated keys have the same keycode.
> For example Jump and  Volume+ or Search and Volume-.
>
> Beside, i keep getting "
> Sep  9 10:17:16 debian kernel: [ 2029.892014] saa7134 IR (ADS Tech 
> Instant TV: unknown key: key=0x7f raw=0x7f down=0
> Sep  9 10:17:16 debian kernel: [ 2029.944029] saa7134 IR (ADS Tech 
> Instant TV: unknown key: key=0x7f raw=0x7f down=1"
> for each recognized keypress
>
> I'll need a lot of help there : i don't know what to do.



