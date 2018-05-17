Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43050 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbeEQMNr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 08:13:47 -0400
Date: Thu, 17 May 2018 09:13:40 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
Message-ID: <20180517091340.7d8c62b2@vento.lan>
In-Reply-To: <20180517084324.3242c257@vento.lan>
References: <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
        <20180423152455.363d285c@vento.lan>
        <3ab9c4c9-0656-a08e-740e-394e2e509ae9@embeddedor.com>
        <20180423161742.66f939ba@vento.lan>
        <99e158c0-1273-2500-da9e-b5ab31cba889@embeddedor.com>
        <20180426204241.03a42996@vento.lan>
        <df8010f1-6051-7ff4-5f0e-4a436e900ec5@embeddedor.com>
        <20180515085953.65bfa107@vento.lan>
        <20180515141655.idzuh2jfdkuu5grs@mwanda>
        <f342d8d6-b5e6-0cbf-d002-9561b79c90e4@embeddedor.com>
        <20180515193936.m25kzyeknsk2bo2c@mwanda>
        <0f31a60b-911d-0140-3546-98317e2a0557@embeddedor.com>
        <d34cf31f-6dc5-ee2d-ea6d-513dd5e8e5c3@embeddedor.com>
        <20180517083440.14e6b975@vento.lan>
        <20180517084324.3242c257@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 May 2018 08:43:24 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> > > > On 05/15/2018 02:39 PM, Dan Carpenter wrote:  
> >   
> > > >> You'd need to rebuild the db (possibly twice but definitely once).  
> > 
> > How? Here, I just pull from your git tree and do a "make". At most,
> > make clean; make.  
> 
> Never mind. Found it using grep. I'm running this:
> 
> 	make allyesconfig
> 	/devel/smatch/smatch_scripts/build_kernel_data.sh
> 	/devel/smatch/smatch_scripts/build_kernel_data.sh

It seems that something is broken... getting this error/warning:

DBD::SQLite::db do failed: unrecognized token: "'end + strlen("
" at /devel/smatch/smatch_scripts/../smatch_data/db/fill_db_sql.pl line 32, <WARNS> line 2938054.


Thanks,
Mauro
