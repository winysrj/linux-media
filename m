Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB21C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C8FF20838
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:57:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="tbJv1UP1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C8FF20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nextdimension.cc
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbeLFQ5H (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 11:57:07 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:7831 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbeLFQ5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 11:57:07 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2018 11:57:05 EST
X-Sender-Id: dreamhost|x-authsender|brad@b-rad.cc
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id CC58D4306D;
        Thu,  6 Dec 2018 16:37:29 +0000 (UTC)
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (unknown [100.96.20.98])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 6C7BA42E88;
        Thu,  6 Dec 2018 16:37:29 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@b-rad.cc
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Thu, 06 Dec 2018 16:37:29 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@b-rad.cc
X-MailChannels-Auth-Id: dreamhost
X-Abortive-Average: 1581caa076dc917d_1544114249680_264752358
X-MC-Loop-Signature: 1544114249680:3376876583
X-MC-Ingress-Time: 1544114249679
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a35.g.dreamhost.com (Postfix) with ESMTP id 073347F5D7;
        Thu,  6 Dec 2018 08:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=
        nextdimension.cc; bh=kkrO0ztESSLLBfdCu8Q8KgYrI74=; b=tbJv1UP18dB
        +qD0PPqKYfEiWqLfsAssKkk4lFnTq9jLhRYjf+a9akYxVeFhw1/SAsgAymG2BT5a
        bE6k2+Npq8X1x6g1lWc/a9v19EUyxuQ6sdjW+osujg5y5HiSeRDfjM6xcqk7tk3J
        F5orpofMqyHAYFHvFE6QL0+QyrIKfGBc=
Received: from [192.168.0.21] (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@b-rad.cc)
        by pdx1-sub0-mail-a35.g.dreamhost.com (Postfix) with ESMTPSA id C5AB17F5CC;
        Thu,  6 Dec 2018 08:37:27 -0800 (PST)
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall fixes
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Dobel <markus.dobel@gmx.de>,
        Brad Love <brad@nextdimension.cc>
Cc:     linux-media@vger.kernel.org
References: <3d7393a6287db137a69c4d05785522d5@gmx.de>
 <20181205090721.43e7f36c@coco.lan>
X-DH-BACKEND: pdx1-sub0-mail-a35
From:   Brad Love <brad@nextdimension.cc>
Openpgp: preference=signencrypt
Autocrypt: addr=brad@nextdimension.cc; prefer-encrypt=mutual; keydata=
 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
Message-ID: <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc>
Date:   Thu, 6 Dec 2018 10:37:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181205090721.43e7f36c@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -70
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudefjedgledtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegfrhhlucfvnfffucdlfedtmdenucfjughrpefuvfhfhffkffgfgggjtgfgsehtqhertddtfeejnecuhfhrohhmpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqnecukfhppeeiiedrledtrddukeelrdduieeinecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopegludelvddrudeikedrtddrvddungdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepmhgthhgvhhgrsgeskhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro & Markus,


On 05/12/2018 05.07, Mauro Carvalho Chehab wrote:
> Em Sun, 21 Oct 2018 15:45:39 +0200
> Markus Dobel <markus.dobel@gmx.de> escreveu:
>
>> The original commit (the one reverted in this patch) introduced a=20
>> regression,
>> making a previously flawless adapter unresponsive after running a few =

>> hours
>> to days. Since I never experienced the problems that the original comm=
it=20
>> is
>> supposed to fix, I propose to revert the change until a regression-fre=
e
>> variant is found.
>>
>> Before submitting this, I've been running a system 24x7 with this reve=
rt=20
>> for
>> several weeks now, and it's running stable again.
>>
>> It's not a pure revert, as the original commit does not revert cleanly=

>> anymore due to other changes, but content-wise it is.
>>
>> Signed-off-by: Markus Dobel <markus.dobel@gmx.de>
>> ---
>>   drivers/media/pci/cx23885/cx23885-core.c | 60 ----------------------=
--
>>   drivers/media/pci/cx23885/cx23885-reg.h  | 14 ------
>>   2 files changed, 74 deletions(-)
>>
>> diff --git a/drivers/media/pci/cx23885/cx23885-core.c=20
>> b/drivers/media/pci/cx23885/cx23885-core.c
>> index 39804d830305..606f6fc0e68b 100644
>> --- a/drivers/media/pci/cx23885/cx23885-core.c
>> +++ b/drivers/media/pci/cx23885/cx23885-core.c
>> @@ -601,25 +601,6 @@ static void cx23885_risc_disasm(struct=20
>> cx23885_tsport *port,
> Patch was mangled by your e-mailer: it broke longer lines, causing
> it to not apply.
>
> Also, before just reverting the entire thing, could you please check
> if the enclosed hack would solve it?
>
> If so, it should be easy to add a quirk at drivers/pci/quirks.c
> in order to detect the Ryzen models with a bad DMA engine that
> require periodic resets, and then make cx23885 to use it.
>
> We did similar tricks before with some broken DMA engines, at
> the time we had overlay support on drivers and AMD controllers
> didn't support PCI2PCI DMA transfers.
>
> Brad,
>
> Could you please address this issue?


I'll try to address this today or tomorrow. Since the original patch was
applied I have not received any complaints from ryzen users, but we have
accumulated a few reports from Intel users with a variety of
motherboards that do now encounter issue. Strangely system load affects
the repro; low/no load exhibits the error condition, high system load
everything is fine. I'll do my best to send in a ryzen specific patch by
the weekend.

Regards,

Brad



>
>
> diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/p=
ci/cx23885/cx23885-core.c
> index 39804d830305..8b012bee6b32 100644
> --- a/drivers/media/pci/cx23885/cx23885-core.c
> +++ b/drivers/media/pci/cx23885/cx23885-core.c
> @@ -603,8 +603,14 @@ static void cx23885_risc_disasm(struct cx23885_tsp=
ort *port,
> =20
>  static void cx23885_clear_bridge_error(struct cx23885_dev *dev)
>  {
> -	uint32_t reg1_val =3D cx_read(TC_REQ); /* read-only */
> -	uint32_t reg2_val =3D cx_read(TC_REQ_SET);
> +	uint32_t reg1_val, reg2_val;
> +
> +	/* TODO: check for Ryzen quirk */
> +	if (1)
> +		return;
> +
> +	reg1_val =3D cx_read(TC_REQ); /* read-only */
> +	reg2_val =3D cx_read(TC_REQ_SET);
> =20
>  	if (reg1_val && reg2_val) {
>  		cx_write(TC_REQ, reg1_val);
>
>
>
> Thanks,
> Mauro

