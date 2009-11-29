Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:1291 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZK2C0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 21:26:01 -0500
Received: by qw-out-2122.google.com with SMTP id 3so496933qwe.37
        for <linux-media@vger.kernel.org>; Sat, 28 Nov 2009 18:26:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091127213939.9bb235fa.ospite@studenti.unina.it>
References: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it>
	<20091127213939.9bb235fa.ospite@studenti.unina.it>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 29 Nov 2009 10:25:47 +0800
Message-ID: <f17812d70911281825q5be6a000p24063a1bf0f17be7@mail.gmail.com>
Subject: Re: [PATCH 0/3] pxa_camera: remove init() callback
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Mike Rapoport <mike@compulab.co.il>,
	Juergen Beisert <j.beisert@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 28, 2009 at 4:39 AM, Antonio Ospite
<ospite@studenti.unina.it> wrote:
> On Tue, 17 Nov 2009 23:04:20 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>
>> Hi,
>>
>> this series removes the init() callback from pxa_camera_platform_data, and
>> fixes its users to do initialization statically at machine init time.
>>
> [...]
>> Antonio Ospite (3):
>>   em-x270: don't use pxa_camera init() callback
>>   pcm990-baseboard: don't use pxa_camera init() callback
>
> Eric, if Guennadi ACKs v2 for these two please apply them only, we are
> postponing the third one, hence you can discard it.
>

OK, fine.
