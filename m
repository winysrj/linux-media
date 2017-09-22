Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:58549 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752276AbdIVRk6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 13:40:58 -0400
Subject: Re: [media] spca500: Use common error handling code in
 spca500_synch310()
To: Julia Lawall <julia.lawall@lip6.fr>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d496ca24-1725-768b-5e55-4e45097cb77d@users.sourceforge.net>
 <alpine.DEB.2.20.1709221908230.3170@hadrien>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <4921ea61-49cd-4071-e636-c199daddec8e@users.sourceforge.net>
Date: Fri, 22 Sep 2017 19:40:35 +0200
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1709221908230.3170@hadrien>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>  	return 0;
>> -error:
>> +
>> +report_failure:
>> +	PERR("Set packet size: set interface error");
>>  	return -EBUSY;
>>  }
> 
> Why change the label name?

I find the suggested variant a bi better.


> They are both equally uninformative.

Which identifier would you find appropriate there?

Regards,
Markus
