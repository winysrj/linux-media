Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50215 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0HKMZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Aug 2010 08:25:48 -0400
Received: by pwj7 with SMTP id 7so17674pwj.19
        for <linux-media@vger.kernel.org>; Wed, 11 Aug 2010 05:25:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <425100.71304.qm@web35805.mail.mud.yahoo.com>
References: <425100.71304.qm@web35805.mail.mud.yahoo.com>
Date: Wed, 11 Aug 2010 08:25:48 -0400
Message-ID: <AANLkTimPKHrB28SVyuyaVBOiWc=ameZgcr2kz=JSh8Y_@mail.gmail.com>
Subject: Re: Error Building the V4L-DVB drivers from source
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Sicoe Alexandru Dan <sicoe_alex@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Aug 11, 2010 at 5:10 AM, Sicoe Alexandru Dan
<sicoe_alex@yahoo.com> wrote:
> Hi,
>  My name is Alex and I recently tried to install the v4l drivers on my machine.
>  Environment:
>    Ubuntu release 10.04(lucid)
>    Kernel Linux 2.6.32-24-generic
>    GNOME 2.30.2

Ubuntu has a bug in their packaging of the kernel headers, which
results in the firedtv driver not building.  Just edit "v4l/.config"
and change the line that says "firedtv=m" to "firedtv=n"

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
