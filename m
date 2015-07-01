Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbbGASHL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jul 2015 14:07:11 -0400
Message-ID: <55942C4C.70209@infradead.org>
Date: Wed, 01 Jul 2015 11:07:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, pawel@osciak.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	mchehab@osg.samsung.com, linux-media <linux-media@vger.kernel.org>
Subject: Re: randconfig build error with next-20150620, in drivers/media/v4l2-core/videobuf2-core.c
References: <CA+r1Zhheo-_o_AJ2sji6FPKNLiHYmjP81__saW7Jv63wMex9BQ@mail.gmail.com>
In-Reply-To: <CA+r1Zhheo-_o_AJ2sji6FPKNLiHYmjP81__saW7Jv63wMex9BQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/15 09:44, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/media/v4l2-core/videobuf2-core.c: In function ‘vb2_warn_zero_bytesused’:
> drivers/media/v4l2-core/videobuf2-core.c:1253:2: error: implicit declaration of
> function ‘__WARN’ [-Werror=implicit-function-declaration]
>   __WARN();
>   ^
> 

When CONFIG_BUG is not enabled, there is no definition of __WARN().

Should be add an empty stub for __WARN() or just change the only
user (caller) of it to do something different?

-- 
~Randy
