Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76D6C31681
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BDC521734
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:46:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hl6VTekQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfAUSqM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 13:46:12 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44819 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfAUSqM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 13:46:12 -0500
Received: by mail-wr1-f66.google.com with SMTP id z5so24549932wrt.11;
        Mon, 21 Jan 2019 10:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=aVzxV0IkABr8yRf2yZfqdYegrJVqmtk73WWhqLWtCGQ=;
        b=Hl6VTekQdfeOZTZsQB1JbhW1iMEjd1YDOZx4qSSic6Wh2ubbZsjh8qKNXow2/gjkES
         E0eNADnN9/m6+nfkT7wm1ACSYuEabYyLjA6EMJ6VRV9HR26vMmxcf96icQaymY+Zj8XJ
         y/7F/QC+RRks5x86dt209UcDxxlBSKUEA3sRVA1NzIxIHg+8MoRunguiCQkMO0xylJS+
         /nHyQ6L6t3hYgawVQwJNhFqLeY2V+6PTmcOK4WpYN5knTqOkwY8fwVxJ2sNK53MpDik/
         +4XzK4Fa61p77ueuETqfgW7EAEvXWKNG9COjCcyiLNlUp/KgE9YDWAXHNimnsEtJ4rF6
         NDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=aVzxV0IkABr8yRf2yZfqdYegrJVqmtk73WWhqLWtCGQ=;
        b=aFCO65lONuKEle1MEwDGEzOryWv+4XZA6RsDMR97P4kzwiai/M1+DtHEufZMrpAEkU
         SBx9Afq4Ty3keDHoJUMPcqSaog7AMG8PcZkLmNZcPEMTn1iDxO98JZjX89rZzfwygVSw
         Iyt6C5l9N+hixGRVgLE4goYIkfAlCR7eV36BviJCw3iKlsEmEQBQ2rCa3YSw5IXG7TcW
         LG8FuMHY/qL7LgPR7IQ6xIRe+iTYb+0H119G0G+wIg7Ns3ZiyrDcAAw4boyEuOexalwk
         QCQuosxxZU7mciISCmeFk7Rbgn+b45UseSWe9Oc6hSYTwBFAxCAam3fWt5KxZ++nt28I
         h+DQ==
X-Gm-Message-State: AJcUukfZLZG9zhlH4gwcehr06IKDb7H1vMyrxAe+QReKf8YEzQvxXPUH
        pbmFR293ZTEGnHiF5iKQuFvfjkS/
X-Google-Smtp-Source: ALg8bN50ojRHw49ENmp0As8/oMRu2EVxJGJBJK+8zGGdj9+3G5b29TUieIbqRoGRRy5LPHVrLxDqPA==
X-Received: by 2002:adf:fbc8:: with SMTP id d8mr28973974wrs.318.1548096369558;
        Mon, 21 Jan 2019 10:46:09 -0800 (PST)
Received: from [172.30.88.24] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id e27sm109694616wra.67.2019.01.21.10.46.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 10:46:09 -0800 (PST)
Subject: Re: [PATCH v3 1/2] media: imx: csi: Disable SMFC before disabling
 IDMA channel
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190119010457.2623-1-slongerbeam@gmail.com>
 <20190119010457.2623-2-slongerbeam@gmail.com>
 <1548071350.3287.3.camel@pengutronix.de>
 <7432d18b-12fc-34c6-832f-576fc1b8e2e8@gmail.com>
Message-ID: <12937f2b-e25e-6cc5-0727-59a5e6224fd9@gmail.com>
Date:   Mon, 21 Jan 2019 10:46:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <7432d18b-12fc-34c6-832f-576fc1b8e2e8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/21/19 10:43 AM, Steve Longerbeam wrote:
>
>
> On 1/21/19 3:49 AM, Philipp Zabel wrote:
>> Also ipu_smfc_disable is refcounted, so if the other CSI is capturing
>> simultaneously, this change has no effect.
>
> Sigh, you're right. Let me go back to disabling the CSI before the 
> channel, the CSI enable/disable is not refcounted (it doesn't need to 
> be since it is single use) so it doesn't have this problem.
>
> Should we drop this patch or keep it (with a big comment)? By only 
> changing the disable order to "CSI then channel", the hang is reliably 
> fixed from my and Gael's testing, but my concern is that by not 
> disabling the SMFC before the channel, the SMFC could still empty its 
> FIFO to the channel's internal FIFO and still create a hang.

Well, as you said it will have no effect if both CSI's are streaming 
with the SMFC, in which case the danger would still exist. Perhaps it 
would be best to just drop this patch.

Steve

