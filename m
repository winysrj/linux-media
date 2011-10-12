Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33450 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1JLOq2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 10:46:28 -0400
Received: by eye27 with SMTP id 27so817695eye.19
        for <linux-media@vger.kernel.org>; Wed, 12 Oct 2011 07:46:27 -0700 (PDT)
Date: Wed, 12 Oct 2011 16:46:32 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Augusto Destrero <destrero@imavis.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Controlling external GPIO in IVC-200G board
Message-ID: <20111012144632.GA614@glitch>
References: <201110121603.46582.destrero@imavis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110121603.46582.destrero@imavis.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 12, 2011 at 04:03:46PM +0200, Augusto Destrero wrote:
> Hi there,

Hi,

> Now we would like to control the external GPIO embedded in the IVC-200G board, 
> but we don't know how to do it.

bttv driver does not expose GPIOs to the userspace but I expect it can be
modified to do so. Have a look at the GPIO_BT8XX driver to see how to do.

Beware that GPIO_BT8XX is thought to drive physically altered boards
(hence not working as brand new product - read the help message of the
driver) while the bttv one has to keep all the other functionalities, so
you may have less GPIO to play with because some are wired to something
on the board itself.

cheers,
Domenico
