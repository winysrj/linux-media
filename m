Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-1b-out-4.atlantis.sk ([80.94.52.30]:50544 "EHLO
        smtp-1b-out-4.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752869AbeF0IC4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 04:02:56 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: safocl <safocl88@gmail.com>
Subject: Re: kernel patch 2018-05-28 media: gspca_zc3xx: Implement proper autogain and exposure control for OV7648
Date: Wed, 27 Jun 2018 10:02:51 +0200
Cc: Hans Verkuil <hansverk@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20180622034913.c005e893af31fd98253315b2@gmail.com> <a9ee3753-82f1-5780-2485-bdd8f8c7d851@cisco.com>
In-Reply-To: <a9ee3753-82f1-5780-2485-bdd8f8c7d851@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201806271002.51712.linux@rainbow-software.org>
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

0ac8:3500 is an UVC camera. This patch does not affect UVC cameras in any way.

-- 
Ondrej Zary
