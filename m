Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:32973
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751657AbdB0KUF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 05:20:05 -0500
Date: Mon, 27 Feb 2017 07:11:22 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: bill murphy <gc2majortom@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Kaffeine commit b510bff2 won't compile
Message-ID: <20170227071122.3a319481@vento.lan>
In-Reply-To: <bafdb165-261c-0129-e0dc-29819a55ca43@gmail.com>
References: <bafdb165-261c-0129-e0dc-29819a55ca43@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 26 Feb 2017 20:57:20 -0500
bill murphy <gc2majortom@gmail.com> escreveu:

> Hi,
> Can someone double check me on this?
> 
> It seems there might be a missing header,
> in the src directory, preventing the last commit from
> compiling. The commit prior compiles fine. So not that big a deal, just 
> letting folks know what I ran in to.
> 
> I don't see this file, 'log.h', anywhere in the src directory. Guessing 
> it wasn't 'added' for tracking?
> 
> git://anongit.kde.org/kaffeine
> 
> diff between master and previous commit...just a snippet, as other files 
> are including the same missing header.
> 
> diff --git a/src/dvb/dvbcam_linux.cpp b/src/dvb/dvbcam_linux.cpp
> index ceb9dbd..5c9c575 100644
> --- a/src/dvb/dvbcam_linux.cpp
> +++ b/src/dvb/dvbcam_linux.cpp
> @@ -18,11 +18,7 @@
>    * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
>    */
> 
> -#include <KLocalizedString>
> -#include <QDebug>
> -#if QT_VERSION < 0x050500
> -# define qInfo qDebug
> -#endif
> +#include "../log.h"
> 
>   #include <errno.h>
>   #include <fcntl.h>
> 
> where compile complains of that missing header...
> 
> Scanning dependencies of target kaffeine
> [ 20%] Building CXX object 
> src/CMakeFiles/kaffeine.dir/dvb/dvbcam_linux.cpp.o
> /home/user/src2/kaffeine/src/dvb/dvbcam_linux.cpp:21:20: fatal error: 
> ../log.h: No such file or directory
> compilation terminated.

Thanks for complaining about it! I forgot to add src/log.h on the
commit.

You should be able to compile it now.

Thanks,
Mauro
