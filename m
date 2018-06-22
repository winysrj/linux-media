Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:43817 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933815AbeFVPvW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:51:22 -0400
Subject: Re: kernel patch 2018-05-28 media: gspca_zc3xx: Implement proper
 autogain and exposure control for OV7648
To: safocl <safocl88@gmail.com>, linux@rainbow-software.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20180622034913.c005e893af31fd98253315b2@gmail.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <a9ee3753-82f1-5780-2485-bdd8f8c7d851@cisco.com>
Date: Fri, 22 Jun 2018 17:51:20 +0200
MIME-Version: 1.0
In-Reply-To: <20180622034913.c005e893af31fd98253315b2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/06/18 01:49, safocl wrote:
> This patch makes it impossible to configure the exposure on webcams, specifically a4tech, with others was not checked. Seen from several users.
> link to the Russian forum archlinux: https://archlinux.org.ru/forum/topic/18581/?page=1
> 
> was checked on webcam a4tech pk-910h idVendor = 0ac8, idProduct = 3500, bcdDevice = 10.07
> 
> with the kernel before this commit, exposure adjustment is possible.
> 
> commit link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?id=6f92c3a22ccd66604b8b528221a9d8e1b3fb4e39
> 

Added linux-media mailinglist.

Regards,

	Hans
