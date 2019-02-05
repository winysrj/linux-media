Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF902C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 13:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 976F720818
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 13:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfBENCj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 08:02:39 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:55278 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbfBENCi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 08:02:38 -0500
Received: from [IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5] ([IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5])
        by smtp-cloud8.xs4all.net with ESMTPA
        id r0N1gPzswNR5yr0N2gpJBv; Tue, 05 Feb 2019 14:02:36 +0100
Subject: Re: [Xen-devel][PATCH v4 1/1] cameraif: add ABI for para-virtual
 camera
To:     Oleksandr Andrushchenko <andr2000@gmail.com>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "koji.matsuoka.xm@renesas.com" <koji.matsuoka.xm@renesas.com>
References: <20190115093853.15495-1-andr2000@gmail.com>
 <20190115093853.15495-2-andr2000@gmail.com>
 <393f824d-e543-476c-777f-402bcc1c0bcb@xs4all.nl>
 <1152536e-9238-4192-653e-b784b34b8a0d@epam.com>
 <d8476f24-1952-e822-aa75-b8a5f5d5a552@gmail.com>
 <e5bbde8f-ef5a-791a-a3aa-645c57ddcf82@xs4all.nl>
 <d26401fd-9e16-548e-cfa0-af488a701b59@gmail.com>
 <3ea2c5a1-b5a1-ba70-ade5-d14cc3aace66@xs4all.nl>
 <08d6da1b-f061-010c-abf8-865564c26d49@gmail.com>
 <de3288c3-2f3a-152f-88f2-e8f2fe690493@xs4all.nl>
 <474636e0-8059-7b75-8b48-a216c6defaf4@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5679f9a9-1218-0cdb-0c61-45864159ab29@xs4all.nl>
Date:   Tue, 5 Feb 2019 14:02:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <474636e0-8059-7b75-8b48-a216c6defaf4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfINvLCuCrCF4VCwbPwUYouRsbSrV4A1Ayoq+Umf8nRl7v8ilLr02w1jtWQYp+ovdVAQ7ER+g01y2D5MP4fDwPSjg7EtC8w5J4jb0Leby34A9cpnt0VPA
 6lUaqXKBt6YXT1g00TV2Li6T9GOcbDL52d/Vx2k5Qf5cEP+udSJ+09vvm/X56siq9f9oVcjwBEebtQsJf/b6SgxB+4gwjGl1gCTXrk6ajrsQktp2320nnq6O
 t8i+2LUKtTyWOuWtVp2nzhRu2jjv9lAJl3+EG2TlzIWz6hnGt9oX/vwtPYUUAn+nIJ1aGp4Tmr37LAjYswegN3SWXUHdvXG5s/4+1qIEuPXQp1vQM7BLFEaH
 gHCxGrppOBrSX039Onmb7l8YBR/YiwfH+2FPv3WxafPo2OTq+qnbDuQtbnDCJBkG0+COVUWOm3xHyLGiae2y++cgIgpMb6ETRZn0h0cyq+1/yfDjPx1pFLCK
 zzqIIjGRZ2E1d5KpB2eWVxbmCx98GhSgk86RJ2KLlZkYLuCrK8jiH7eE9Hea5wo/B+rM2vNMcmed7wzlIcqahhryKv0jB1Jjx+wj3rLIllQTQ4wyF1VaGlkS
 mKHugAZ6r+kj7kpzdBf0K30n
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/5/19 1:30 PM, Oleksandr Andrushchenko wrote:
>> Sorry for paying so much attention to this, but I think it is important that
>> this is documented precisely.
> Thank you for helping with this - your comments are really
> important and make the description precise. Ok, so finally:
> 
>  * num_bufs - uint8_t, desired number of buffers to be used.
>  *
>  * If num_bufs is not zero then the backend validates the requested number of
>  * buffers and responds with the number of buffers allowed for this frontend.
>  * Frontend is responsible for checking the corresponding response in order to
>  * see if the values reported back by the backend do match the desired ones
>  * and can be accepted.
>  * Frontend is allowed to send multiple XENCAMERA_OP_BUF_REQUEST requests
>  * before sending XENCAMERA_OP_STREAM_START request to update or tune the
>  * final configuration.
>  * Frontend is not allowed to change the number of buffers and/or camera
>  * configuration after the streaming has started.
>  *
>  * If num_bufs is 0 and streaming has not started yet, then the backend may
>  * free all previously allocated buffers (if any) or do nothing.

I would rephrase this:

* If num_bufs is 0 and streaming has not started yet, then the backend will
* free all previously allocated buffers (if any).

The previous text suggested that the backend might choose not to free
the allocated buffers, but that's not the case.

>  * Trying to call this if streaming is in progress will result in an error.
>  *
>  * If camera reconfiguration is required then the streaming must be stopped
>  * and this request must be sent with num_bufs set to zero and finally
>  * buffers destroyed.
>  *
>  * Please note, that the number of buffers in this request must not exceed
>  * the value configured in XenStore.max-buffers.
>  *
>  * See response format for this request.

With that small change the text looks good to me.

Regards,

	Hans
