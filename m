Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:14662 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752457AbdC2Rah (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 13:30:37 -0400
Message-ID: <1490808631.3367.5.camel@linux.intel.com>
Subject: Re: [PATCH v2] staging: media: atomisp: Fix style. remove space
 before ',' and convert to tabs.
From: Alan Cox <alan@linux.intel.com>
To: Daniel Cashman <dan.a.cashman@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org
Cc: rvarsha016@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 29 Mar 2017 18:30:31 +0100
In-Reply-To: <1490806677-4500-1-git-send-email-dan.a.cashman@gmail.com>
References: <20170329070815.GA11051@kroah.com>
         <1490806677-4500-1-git-send-email-dan.a.cashman@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-03-29 at 09:57 -0700, Daniel Cashman wrote:
> From: Dan Cashman <dan.a.cashman@gmail.com>
> 
> Signed-off-by: Dan Cashman <dan.a.cashman@gmail.com>


As the TODO asks - please no whitespace cleanups yet. They make it
harder to keep other cleanups that fix (or mostly remove) code
applying.

Nothing wrong with the patch otherwise - but it should also have
something in the commit message.

Alan
