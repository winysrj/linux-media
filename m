Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44396 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbdIMIpx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 04:45:53 -0400
Date: Wed, 13 Sep 2017 11:45:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Allen <allen.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers:staging/media:Use ARRAY_SIZE() for the size
 calculation of the array
Message-ID: <20170913084533.bc6gg65tveozddks@mwanda>
References: <1505289879-26163-1-git-send-email-allen.lkml@gmail.com>
 <20170913082211.2btqdehfq7co4mtx@mwanda>
 <CAOMdWSKVi_3tjxZ6=uoakyLthnYX4ng6o4PRMoikN4Y8qr_UDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSKVi_3tjxZ6=uoakyLthnYX4ng6o4PRMoikN4Y8qr_UDQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also change the subject prefix to: [media] atomisp: so it's:

Subject: [PATCH v2] [media] atomisp: Use ARRAY_SIZE() instead of open coding it

regards,
dan carpenter
