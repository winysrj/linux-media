Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:55284 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2LFCQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2012 21:16:24 -0500
Message-ID: <50BFFFF6.1000204@pyther.net>
Date: Wed, 05 Dec 2012 21:16:22 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi>
In-Reply-To: <50BFECEA.9060808@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/05/2012 07:55 PM, Antti Palosaari wrote:
>
> It was good snoop. I didn't saw nothing very interesting. But, I think 
> I found the reason. Just add that one line writing 0x42 to register 
> 0x0d. IIRC I saw earlier it caused that kind of bug...
>
> +static struct em28xx_reg_seq msi_digivox_atsc[] = {
> +    {EM2874_R80_GPIO, 0xff, 0xff,  50}, /* GPIO_0=1 */
> +    {0x0d,            0xff, 0xff,   0},
> +    {EM2874_R80_GPIO, 0xfe, 0xff,   0}, /* GPIO_0=0 */
>     {0x0d,            0x42, 0xff,   0},
> +    {EM2874_R80_GPIO, 0xbe, 0xff, 135}, /* GPIO_6=0 */
> +    {EM2874_R80_GPIO, 0xfe, 0xff, 135}, /* GPIO_6=1 */
> +    {EM2874_R80_GPIO, 0x7e, 0xff,  20}, /* GPIO_7=0 */
> +    {             -1,   -1,   -1,  -1},
> +};
>
> regards
> Antti
>
>
I added that line, recompiled, tried the new module. Unfortunately there 
was no improvement. I didn't see any differences in any of the output 
(dmesg, azap). Let me know if there is any info you want me to get.

Matthew
