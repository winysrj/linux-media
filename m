Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33944 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbbG2PVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2015 11:21:48 -0400
Received: by wibud3 with SMTP id ud3so225426250wib.1
        for <linux-media@vger.kernel.org>; Wed, 29 Jul 2015 08:21:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559A915B.20305@vanguardiasur.com.ar>
References: <m3bnftphea.fsf@t19.piap.pl>
	<m37fqhpe35.fsf@t19.piap.pl>
	<559A915B.20305@vanguardiasur.com.ar>
Date: Wed, 29 Jul 2015 12:21:47 -0300
Message-ID: <CAAEAJfDP6YpEAgjyn83pq3-7YjdQpHsj79cE6k=+2YrwMYBPow@mail.gmail.com>
Subject: Re: [PATCH] [MEDIA] Add support for TW686[4589]-based frame grabbers.
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
	linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

In case anyone is interested in this device, I'm maintaining an
out-of-tree driver:

https://bitbucket.org/vanguardiasur/tw686x/

It supports audio and DMA frame/S-G modes (with a module parameter).

Testing and bug reports are welcome :-)
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
