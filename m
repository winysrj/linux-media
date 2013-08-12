Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:55667 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752317Ab3HLR7E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Aug 2013 13:59:04 -0400
Date: Mon, 12 Aug 2013 14:59:03 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Luis Polasek <lpolasek@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	"jbucar@lifia.info.unlp.edu.ar" <jbucar@lifia.info.unlp.edu.ar>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick BOETTCHER <patrick.boettcher@parrot.com>
Subject: Re: dib8000 scanning not working on 3.10.3
Message-ID: <20130812175901.GC7198@localhost>
References: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
 <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
 <20130801163624.GA10498@localhost>
 <20130801141518.258ff0a3@samsung.com>
 <CAER7dwe9biLNZKtW6xQmD8J0Qmh4dMTi=chpUuQ_Dq5KKxJ5UQ@mail.gmail.com>
 <20130805172605.1ba32958@samsung.com>
 <CAER7dwcDxa4=i453tOU21ZJP9Opd01mZ-QYrLpQTcgB_yU4B+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAER7dwcDxa4=i453tOU21ZJP9Opd01mZ-QYrLpQTcgB_yU4B+Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Luis,

On Wed, Aug 07, 2013 at 03:48:33PM -0300, Luis Polasek wrote:
> Hi again Mauro, reverting both commits:
> 
> *  59501bb792c66b85fb7fdbd740e788e3afc70bbd
> *  f45f513a9325b52a5f3e26ee8d15471e8b692947
> 
> The problem still exists, I am unable to get any result, and also no
> error logs) :(
> 
> What shall I do to try to fix this ? Do you need more info on my current setup.
> 

Have you tried a git bisect? It's a PITA, but it's a safe
way to find the guilty commit.

Don't hesitate in asking for help if you're not sure how this is done.

PS: Try to avoid top-posting.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
