Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:48405 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753299AbdF2Pfh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 11:35:37 -0400
Subject: Re: Trying to use IR driver for my SoC
From: Mason <slash.tmp@free.fr>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
References: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
Message-ID: <a49e0c85-f95b-b952-e972-6d9049725cd7@free.fr>
Date: Thu, 29 Jun 2017 17:35:26 +0200
MIME-Version: 1.0
In-Reply-To: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/06/2017 17:29, Mason wrote:

> I suppose I am missing some important piece of the puzzle?
> I hope someone can point me in the right direction.

FWIW,

$ ir-keytable -v
Found device /sys/class/rc/rc0/
Input sysfs node is /sys/class/rc/rc0/input0/
Couldn't find any node at /sys/class/rc/rc0/input0/event*.
Segmentation fault

$ ir-keytable --version
IR keytable control version 1.12.2

Regards.
