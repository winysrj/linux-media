Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:48809 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750880AbeDNKGk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 06:06:40 -0400
Subject: Re: Smatch and sparse errors
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        LMML <linux-media@vger.kernel.org>
References: <20180411122728.52e6fa9a@vento.lan>
 <fc6e68a3-817b-8caf-ba4f-dd2ed76d2a52@anw.at>
 <20180414064648.0ad264fa@vento.lan>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <4ecc96e9-fb47-3365-cd33-c35febba801d@anw.at>
Date: Sat, 14 Apr 2018 12:06:34 +0200
MIME-Version: 1.0
In-Reply-To: <20180414064648.0ad264fa@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro/Hans!

> Then you're probably not using the right version
Might be ...
The build script from Hans uses the Versions from here:
   git://repo.or.cz/smatch.git
   git://git.kernel.org/pub/scm/devel/sparse/sparse.git

> Yesterday, I added both trees I'm using here at:
> 	https://git.linuxtv.org/mchehab/sparse.git/
> 	https://git.linuxtv.org/mchehab/smatch.git/
Maybe we should use your version in the build script.
Hans?

> IMHO, all 4 patches are disabling false-positive only warnings,
> although the 4th patch might have something useful, if fixed to
> properly handle the 64-bit compat macros.
Another good reason for using your version. Doing so, you can fix/extend
sparse/smatch and the daily build will automatically use that.

BR,
   Jasmin
