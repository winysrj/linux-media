Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:37133 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3EMMqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 08:46:39 -0400
Received: by mail-ea0-f172.google.com with SMTP id d10so417328eaj.17
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 05:46:38 -0700 (PDT)
From: Federico Vaga <federico.vaga@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@redhat.com, hans.verkuil@cisco.com,
	giancarlo.asnaghi@st.com, prabhakar.csengg@gmail.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] sta2x11_vip: fix error return code in sta2x11_vip_init_one()
Date: Mon, 13 May 2013 14:46:53 +0200
Message-ID: <152054915.14cJhqgY8Y@harkonnen>
In-Reply-To: <CAPgLHd87Pzp=OCzOb__5nTv0dy-_hbVeZv6buz__uv-sfYiuww@mail.gmail.com>
References: <CAPgLHd8UFD4p=PAK+Ukno8qvmvaxVxvSrrZw=qpUtERCyP7hpg@mail.gmail.com> <44148472.RS4fqJslTV@harkonnen> <CAPgLHd87Pzp=OCzOb__5nTv0dy-_hbVeZv6buz__uv-sfYiuww@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 13 May 2013 20:40:33 Wei Yongjun wrote:
> On 05/13/2013 08:19 PM, Federico Vaga wrote:
> > Hello,
> > 
> > I agree with the content of the patch, but I disagree with the commit
> > message.> 
> > >From the commit message it seems that you fixed a bug about the error
> > >code,
> > 
> > but the aim of this patch is to uniform the code style. I suggest
> > something
> > like: "uniform code style in sta2x11_vip_init_one()"
> 
> The orig code will release all the resources if v4l2_device_register()
> failed and return 0.
> But what we need in this case is to return an negative error code
> to let the caller known we are failed. So the patch save the return
> value of v4l2_device_register() to 'ret' and return it when error.

Oh sure, you are right :)
I did not understand it immediately from the commit message. Can you put this 
answer as commit message? It is perfectly clear where is the bug now.

Thank you
-- 
Federico Vaga
