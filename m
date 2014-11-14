Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50021 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934728AbaKNLmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 06:42:51 -0500
Received: by mail-pd0-f175.google.com with SMTP id w10so1494132pde.20
        for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 03:42:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m3sihmf3mc.fsf@t19.piap.pl>
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
	<m3sihmf3mc.fsf@t19.piap.pl>
Date: Fri, 14 Nov 2014 15:42:50 +0400
Message-ID: <CANZNk81y8=ugk3Ds0FhoeYBzh7ATy1Uyo8gxUQFoiPcYcwD+yQ@mail.gmail.com>
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas
 or help?
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: =?ISO-8859-2?Q?Krzysztof_Ha=B3asa?= <khalasa@piap.pl>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-11-14 15:00 GMT+04:00 Krzysztof Hałasa <khalasa@piap.pl>:
> There is a race condition in the IRQ handler, at least in 3.17.
> I don't know if it's related, will post a patch.

Thank you for your interest.
Looking forward for your patch. If you don't have time, please just
say what races with what, I'll check by myself.

-- 
Andrey Utkin
