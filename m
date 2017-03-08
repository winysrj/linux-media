Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:38793 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756721AbdCHEkv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 23:40:51 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v284dQSH008126
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 8 Mar 2017 04:39:26 GMT
Date: Wed, 8 Mar 2017 07:38:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Wu, Songjun" <Songjun.Wu@microchip.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [bug report] [media] atmel-isc: add the isc pipeline function
Message-ID: <20170308043814.GD4120@mwanda>
References: <20170307001729.GA1588@mwanda>
 <dbe0c888-815d-b981-a9c9-9c7283e81ee0@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbe0c888-815d-b981-a9c9-9c7283e81ee0@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No.  Imagine the v4l2_subdev_call() loop exits with "fmt" set to NULL.
It will cause a crash.

Please re-read my original email because I think you may have meant to
reset fmt after that loop.

regards,
dan carpenter
