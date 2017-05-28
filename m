Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:44864 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbdE1UAn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 16:00:43 -0400
Date: Sun, 28 May 2017 20:58:22 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Chen Guanqiao <chen.chenchacha@foxmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com, fengguang.wu@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: atomisp: lm3554: fix sparse warnings(was not
 declared. Should it be static?)
Message-ID: <20170528205822.190660f6@alans-desktop>
In-Reply-To: <20170528180641.9152-1-chen.chenchacha@foxmail.com>
References: <20170528180641.9152-1-chen.chenchacha@foxmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 May 2017 02:06:41 +0800
Chen Guanqiao <chen.chenchacha@foxmail.com> wrote:

> Fix "symbol 'xxxxxxx' was not declared. Should it be static?" sparse warnings.
> 
> Signed-off-by: Chen Guanqiao <chen.chenchacha@foxmail.com>
> ---

Reviewed-by: Alan Cox <alan@linux.intel.com>
