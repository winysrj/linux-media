Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63085 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932558AbdC3Kwt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:52:49 -0400
Message-ID: <1490871164.4738.0.camel@linux.intel.com>
Subject: Re: [PATCH 1/2] staging: atomisp: simplify the if condition in
 atomisp_freq_scaling()
From: Alan Cox <alan@linux.intel.com>
To: Daeseok Youn <daeseok.youn@gmail.com>, mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Thu, 30 Mar 2017 11:52:44 +0100
In-Reply-To: <20170330062449.GA25214@SEL-JYOUN-D1>
References: <20170330062449.GA25214@SEL-JYOUN-D1>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-03-30 at 15:24 +0900, Daeseok Youn wrote:
> The condition line in if-statement is needed to be shorthen to
> improve readability.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---

How about a define for ATOMISP_IS_CHT(isp) instead - as we will need
these tests in other places where there are ISP2400/ISP2401 ifdefs ?

Alan
