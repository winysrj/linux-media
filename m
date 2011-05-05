Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53524 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab1EECxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 22:53:34 -0400
Received: by gyd10 with SMTP id 10so623575gyd.19
        for <linux-media@vger.kernel.org>; Wed, 04 May 2011 19:53:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1105040901330.23196@axis700.grange>
References: <BANLkTiku=G-9rJQT9i59CzQkJ+RSo2fPSA@mail.gmail.com>
	<Pine.LNX.4.64.1105030817030.15004@axis700.grange>
	<BANLkTimGMVv5FekMea0M5pLTtOB30PNXdw@mail.gmail.com>
	<Pine.LNX.4.64.1105040901330.23196@axis700.grange>
Date: Thu, 5 May 2011 10:48:13 +0800
Message-ID: <BANLkTik1sg=H7DZxVDZJjUtqF9LSf8-ssw@mail.gmail.com>
Subject: Re: problems on soc-camera subsystem
From: =?GB2312?B?wNbD9A==?= <lemin9538@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear Guennadi:

> You should use different IDs. Look at arch/sh/boards/mach-migor/setup.c or
> arch/arm/mach-mx3/mach-pcm037.c for examples.
>

     Thank you for your help,The above sentence gives me the answer.Today
I studied the platform_device subsystem again,and understant that if
you want  to register platform devices  who has the same name,you must
give each of them a different ID.what a easy problem,but cost you so
much time to interpret  for me,I am so sorry.

Thanks
LeMin
