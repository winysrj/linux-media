Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:50910 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbJBW2J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 18:28:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	kernel@stlinux.com,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Maxime Coquelin <maxime.coquelin@st.com>
Subject: Re: [PATCH 6/7] [media] c8sectpfe: fix namespace on memcpy/memset
Date: Sat, 03 Oct 2015 00:27:34 +0200
Message-ID: <5577273.mIdflaHak0@wuerfel>
In-Reply-To: <5347f97c651906887446a8811946e54b5a972fe4.1443737683.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com> <5347f97c651906887446a8811946e54b5a972fe4.1443737683.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 October 2015 19:17:28 Mauro Carvalho Chehab wrote:
> @@ -1084,10 +1084,10 @@ static void load_dmem_segment(struct c8sectpfei *fei, Elf32_Phdr *phdr,
>                 seg_num, phdr->p_paddr, phdr->p_filesz,
>                 dst, phdr->p_memsz);
>  
> -       memcpy((void __iomem *)dst, (void *)fw->data + phdr->p_offset,
> +       memcpy((void __force *)dst, (void *)fw->data + phdr->p_offset,
>                 phdr->p_filesz);
>  
> -       memset((void __iomem *)dst + phdr->p_filesz, 0,
> +       memset((void __force *)dst + phdr->p_filesz, 0,
>                 phdr->p_memsz - phdr->p_filesz);
>  }
> 
Same here: this should really use memcpy_toio() for the first one, though it
seems we don't have a corresponding memset_io().

	Arnd
