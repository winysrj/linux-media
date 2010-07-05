Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0GEWKc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 18:10:32 -0400
Message-ID: <4C325855.2080000@redhat.com>
Date: Mon, 05 Jul 2010 19:10:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Veit.Berwig@fimi.landsh.de
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Technisat AirStar TeleStick 2
References: <36BCFE472FE7984D89C9B04F1E76EBA5131F6C@fm-dc1.lr.landsh.de>
In-Reply-To: <36BCFE472FE7984D89C9B04F1E76EBA5131F6C@fm-dc1.lr.landsh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 30-06-2010 11:47, Veit.Berwig@fimi.landsh.de escreveu:
> 
> Hello V4L-Team,
> 
> here is a short description of my patch for the
> "Technisat AirStar TeleStick 2" USB-DVB adapter.
> 
> The "AirStar TeleStick 2" from Technisat contains
> an full integrated asic from DiBcom, the
> DIB7770-PA (tuner + demodulator + USB bridge).
> 
> It is shiped with a TS035 remote.
> 
> I added the Device-ID and some stuff near the
> code for loading the DIB0700-firmware.
> 
> The stick works fine ! Tuning, video and sound
> works without errors and stable. I tested this
> stuff under Kernel 2.6.27.27.

Please re-base your patch against upstream tree, generate it
at the unified format, and send it in-lined. 
You also need to add your Signed-off-by:

LinuxTV.org wiki is your friend. It contains several information
that helps you to properly submit your patches.

> 
> Greetings,
>  veit berwig
> 
> -----BEGIN PGP PUBLIC KEY BLOCK-----
> Version: GnuPG v1.4.9 (MingW32)
> Comment: Sichern Sie Ihre Mitteilungen mit GnuPG und GPGSX !
> Comment: ===================================================
> 
> mQGiBElHwnIRBAChSjFMtb+tdsfNPPC8UnP+9PR9TPAoRWVHJ2U1zk8i37fssfhD
> fFMUinCcfmErdk8aCnFlJTcdj5rtzHpV+qwZ8eI06uuLlKN9nnyhpErrGgE26eS7
> YvZIcymVdOo4gHggNanfuQxa9OCGsVLAbLuOkrnF/fP2+12PZhXw/wVgywCgv1HB
> TrrQ8WxLHZiNa3xNleWJvOUD/0HBRqqdb8dV0IQrl78kyQqe2f1ZEQs097hyL2wg
> 2nBVT6VUF+IVNl/m2lxCXfV7a+/+xA9/x1uBlGPkJiO8yxemrqhTGr1vQGoPBI3f
> bukYzhAJq0gnRUjXwbCSLjnuRlAT8VkjHhdJ1kfI1gsSe1E0OqapJO/QZlfmi425
> Fhg3A/9sF7CMiJokme0ECVDWAobC8JTwG67mZ2KgfeY5PiAQ5cPCF6XBZXOr8Dls
> rkJ/rAHrBELH8nBX8Cb+W059FXSMUqlDJdZYejumRpEz5cdbQtquuVWeyQQpj8Xm
> 97IIR2o226k2oVFEZtpw58PUcdYpwjl1qk5zP6Gi9Mot07XlEbQoVmVpdCBCZXJ3
> aWcgPHZlaXQuYmVyd2lnQGZpbWkubGFuZHNoLmRlPohgBBMRAgAgBQJJR8JyAhsj
> BgsJCAcDAgQVAggDBBYCAwECHgECF4AACgkQ1yqoDtvs9NnNUgCgkLxdP2EZl+b/
> ZpPCvC1tw4vUn1YAn0R4svbplnzrpi6h1fynIqv22NMyuQINBElHwnIQCADbqXtH
> fynLNckiwqDnznWY5JNOlacoG+ge53Rk7DmXUv1TH2dLcDsd/UGlIcS43jEUUhLa
> 6l4vF+uT6hwaXYirhy/leZ90HMDd5xM+bqL+/CUWcrGBF4ig40HKUziXVQOn/9ZY
> 4FJChDyAZxIaC3xExPOMB8MQ/ijCJe6Z3GPIJU1T/GHuhC3okU0q4Bor6wHjgwNs
> ZRNSzHogNnIgTa566aKhnD1++QS2pb8NFn5Ok6VWIEJEg8HJz9Ak0WSjQ0H6fb/u
> mW+iOu4DO1nIPYUAbYGAo6gSEWJFQwwwIeopm5hW7HsgL3ZwzU5ku6cTpy5/CH5u
> XYe1Pt2tCfbFSGEPAAURB/9xf65FGfggJTjiBqk4XDA4vAj8VBNFz1McySpIORMq
> xAB3R00e5j4albVTKEhxcdSzB5go1ldkaHpG8d2rPpalpp05IfWXDl3OTl9uyapt
> O3iMw7OzmWkOC2VCfftEI8NQsHK6Sux3CoQaZ2YD48EnPFWfBAfxIxmP223U4naz
> Z+2AZdEEdnyizXmJQ5UiqX8DUCewhTdXvUEmfFL42fnljbTio7EDrUj8l7BJAESb
> uY9aUl3x13+a4yvnAb898sxwX4sUwa1n0nv1de+vM8grsykxXjqOJW8/t+HIA8+f
> DibtHhS0aUDh16n7fkboiBDC8MxvPMnJAG8qX5QhlNediEkEGBECAAkFAklHwnIC
> GwwACgkQ1yqoDtvs9Nn35ACdHQukq/1buapWoCR3TqykOemaF+gAnRz8cKJzqUd3
> A4kJcW4v2VCN9hsy
> =CW0b
> -----END PGP PUBLIC KEY BLOCK-----
> 

