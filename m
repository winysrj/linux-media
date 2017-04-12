Return-path: <linux-media-owner@vger.kernel.org>
Received: from exchange.mail.starnet.cz ([92.62.224.72]:39344 "EHLO
        EXCHANGE.mail.starnet.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752807AbdDLLAh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 07:00:37 -0400
From: =?iso-8859-2?Q?Milan_=C8=ED=BEek?= <milan.cizek@mail.starnet.cz>
To: "'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
Date: Wed, 12 Apr 2017 13:00:34 +0200
Subject: please help with uninstall
Message-ID: <B77D5CB33CF0C84684BD47DA74ADC87A014CAD26D74E@EXCHANGE.mail.starnet.cz>
Content-Language: cs-CZ
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

How to remove your product from my kernel? I tried make rmmod rminstall but this message stills in my syslog.
Sorry for question, I'm linux newbie.

[   15.753993] WARNING: You are using an experimental version of the media stack.
                As the driver is backported to an older kernel, it doesn't offer
                enough quality for its usage in production.
                Use it with care.
               Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
                427ae153c65ad7a08288d86baf99000569627d03 [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal
                ea2e813e8cc3492c951b9895724fd47187e04a6f [media] tlg2300: move to staging in preparation for removal
                c1d9e03d4ef47de60b414fa25f05f9c867f43c5a [media] vino/saa7191: move to staging in preparation for removal

Milan
