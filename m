Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57359 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700Ab2BGH6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Feb 2012 02:58:19 -0500
Received: by obcva7 with SMTP id va7so7950067obc.19
        for <linux-media@vger.kernel.org>; Mon, 06 Feb 2012 23:58:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACKLOr045hbPspwbM_rONNOQhPv+v0Gn+zLXr=5jqKfXVO7__g@mail.gmail.com>
References: <CA+V-a8vBpt1WqHxD2OqYTTfU7SFZ=1QQfqae3kpzu6U-opHEwg@mail.gmail.com>
	<CACKLOr045hbPspwbM_rONNOQhPv+v0Gn+zLXr=5jqKfXVO7__g@mail.gmail.com>
Date: Tue, 7 Feb 2012 13:28:18 +0530
Message-ID: <CA+V-a8vXOri0nKarSgiTLPY4s67byp8aqxt1SDKSNcxzOW8B+w@mail.gmail.com>
Subject: Re: videobuf2 porting
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Tue, Feb 7, 2012 at 1:17 PM, javier Martin
<javier.martin@vista-silicon.com> wrote:
> Hi Prabhakar,
>
> On 7 February 2012 08:16, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
>> Hi folks,
>>
>> I was trying to port a existing driver to videobuf2 framework, I had a
>> hurdle in between
>> the driver I was trying to port supports user pointer, How does
>> videobuf2 support this
>> thing ?
>
> If the driver you are trying to port supports old videobuf framework
> this patch might be useful for you:
>
> http://patchwork.linuxtv.org/patch/9719/
   Thanks for the link, ill have a  look at it.

WBR,
--Prabhakar lad

>
> --
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com
