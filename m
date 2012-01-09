Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44383 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2AIKW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 05:22:27 -0500
Received: by wibhm6 with SMTP id hm6so2417739wib.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2012 02:22:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <00ef01ccceb7$68f0cb90$3ad262b0$%szyprowski@samsung.com>
References: <1325693947-8848-1-git-send-email-javier.martin@vista-silicon.com>
	<00ef01ccceb7$68f0cb90$3ad262b0$%szyprowski@samsung.com>
Date: Mon, 9 Jan 2012 11:22:26 +0100
Message-ID: <CACKLOr2ZvXF1o9QStWL+QQnu9mggvQzdPSW2gDvkBJxwo5+=9A@mail.gmail.com>
Subject: Re: [PATCH 1/2 v4] media: vb2: support userptr for PFN mappings.
From: javier Martin <javier.martin@vista-silicon.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On 9 January 2012 11:14, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Hello,
>
> On Wednesday, January 04, 2012 5:19 PM Javier Martin wrote:
>
>> Some video devices need to use contiguous memory
>> which is not backed by pages as it happens with
>> vmalloc. This patch provides userptr handling for
>> those devices.
>>
>> ---
>> Changes since v3:
>>  - Remove vma_res variable.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
>
> Do you plan to put a git tree with all your patches and send a pull request
> to Mauro? If not I will take this patch and put it on my vb2 branch.

Is this mandatory for Mauro to merge one's patches? Because I've sent
several patches in the patch and haven't received response yet.

Anyway, I prefer you to take this patch.

Thank you.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
