Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55355 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbZFORm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 13:42:56 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Alexey Klimov <klimov.linux@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Mon, 15 Jun 2009 12:42:51 -0500
Subject: RE: [PATCH 10/10 - v2] common vpss module for video drivers
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF9364@dlee06.ent.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-3-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-4-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-5-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-6-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-7-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-8-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-9-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-10-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-11-git-send-email-m-karicheri2@ti.com>
 <208cbae30906111623s3cf1939emb552ef465fed4cea@mail.gmail.com>
In-Reply-To: <208cbae30906111623s3cf1939emb552ef465fed4cea@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


=
>dm644x_clear_wbl_overflow;
>> +       else
>> +               return -ENODEV;
>
>Do you need clean up procedure if you return error here? I mean -
>calls to release_mem_region, release_mem_region, etc
>
Oops! I need to add that. Thanks.
>> +       spin_lock_init(&oper_cfg.vpss_lock);
>> +       dev_info(&pdev->dev, "%s vpss probe success\n",
>oper_cfg.vpss_name);
>> +       return 0;
>> +fail3:
>> +       release_mem_region(oper_cfg.r2->start, oper_cfg.len2);
>> +fail2:
>> +       iounmap(oper_cfg.vpss_bl_regs_base);
>> +fail1:
>> +       release_mem_region(oper_cfg.r1->start, oper_cfg.len1);
>> +       return status;
>> +}
>
>
>--
>Best regards, Klimov Alexey

