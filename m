Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:17601 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbZHTStr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 14:49:47 -0400
Received: by fg-out-1718.google.com with SMTP id e12so62592fga.17
        for <linux-media@vger.kernel.org>; Thu, 20 Aug 2009 11:49:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250793946.4644.45.camel@sl>
References: <1250790879.4644.33.camel@sl>
	 <829197380908201112m2c6fac29ve62d3e2bdf035bf2@mail.gmail.com>
	 <1250793946.4644.45.camel@sl>
Date: Thu, 20 Aug 2009 14:49:47 -0400
Message-ID: <829197380908201149v58d69300kb607abbc16671eca@mail.gmail.com>
Subject: Re: [PATCH] em28xx: Add entry for GADMEI UTV330+ and related IR codec
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Shine Liu <shinel@foxmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 20, 2009 at 2:45 PM, Shine Liu<shinel@foxmail.com> wrote:
>
>
> Hi Devin,
>
> Thanks for your suggestion. From the dmesg, I got the information:
>
> em28xx #0: Board i2c devicelist hash is 0x4ba50080
>
> I've regenerated the patch used the i2c hash value 0x4ba50080.
>
> |-------------------------------------------------------------------|
> |Sorry for the last wrong mail, "ir_codes_gadimei_rm008z" should be |
> |"ir_codes_gadmei_rm008z". This patch is correct.                   |
> |-------------------------------------------------------------------|
>
> Best regard,
>
> Shine

Looks good to me:

Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
