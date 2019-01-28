Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F0EC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06A4F20881
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfA1PqD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:46:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54825 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbfA1PqC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 10:46:02 -0500
Received: from mail-pg1-f197.google.com ([209.85.215.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1go96l-0001vK-J7
        for linux-media@vger.kernel.org; Mon, 28 Jan 2019 15:45:59 +0000
Received: by mail-pg1-f197.google.com with SMTP id i124so11809251pgc.2
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 07:45:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nq6JTSJH6G0iYSpP6totTHMc42vImfy4GfVb8SES63U=;
        b=d9cJtngltbT1cUcwF5ET3OXbOAOxbBGsHnUvgbTgXDGUWPD+nXveVpILLFkPboYr2+
         aY530WAqDLKbaT8OkpmCN8NfxuUdMveBXGWslFMlHP1kui66VItnHgcHfvqthXas74ta
         pMk2rXMyBHoHpXYSP2u56DC1AB/Kuf0o+YxaEIbg9ZgKtc9cH/RuHRsSE2J/+PPuf8NS
         vdoplAzhK+ycB7Y4ZS4fQ1G0Hx8Nw4uVZ73dvEBIpArF/fo9Fei0F5ah1QhGHgXs0RPX
         XnOyz+p9kLFDPdbq5H4T6ohQoOO7e6qEl8P9RyM9+VMAlBH1Y6FvrDQ+s7a9ZrbAgk1Q
         fzvQ==
X-Gm-Message-State: AJcUukejtzvBLMferdq7+NVSQMXDA22eBcfaNlLWC5sqEIs0GAcLZML8
        5g7RZHFo4tZ2aOD8IdgIcuuNERcf+lKgEjvJsErr9IE4RIal7wHV4BTEH+UJf8N7YgCxjRDKAlo
        vczU475pxjeso4S3bp+6YBceTAt/afVpKSKor+OMF
X-Received: by 2002:a17:902:b707:: with SMTP id d7mr21277238pls.29.1548690358009;
        Mon, 28 Jan 2019 07:45:58 -0800 (PST)
X-Google-Smtp-Source: ALg8bN5djhrjhS6e/Z9ND7S+hfMKONeH/4W5zEJzENe+/VvshX4sO3pRu2nJf8vPJilNtYlfE8hRjA==
X-Received: by 2002:a17:902:b707:: with SMTP id d7mr21277208pls.29.1548690357520;
        Mon, 28 Jan 2019 07:45:57 -0800 (PST)
Received: from [192.168.1.215] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id d6sm47420772pgc.89.2019.01.28.07.45.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 07:45:56 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: ipu3-imgu 0000:00:05.0: required queues are disabled
From:   Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <ac9cd5cd-82af-48c7-5b12-adacb540480c@ideasonboard.com>
Date:   Mon, 28 Jan 2019 23:45:52 +0800
Cc:     sakari.ailus@linux.intel.com, bingbu.cao@intel.com,
        yong.zhi@intel.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        LibCamera Devel <libcamera-devel@lists.libcamera.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <76CB59A0-D8F2-4C01-A600-60138ED5E785@canonical.com>
References: <7F8ED1B6-5070-437A-A745-AE017D8CE0DF@canonical.com>
 <ac9cd5cd-82af-48c7-5b12-adacb540480c@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
X-Mailer: Apple Mail (2.3445.102.3)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

> On Jan 28, 2019, at 4:48 PM, Kieran Bingham <kieran.bingham@ideasonboard.com> wrote:
> 
> Hi Kai-Heng,
> 
> On 27/01/2019 05:56, Kai-Heng Feng wrote:
>> Hi,
>> 
>> We have a bug report [1] that the ipu3 doesn’t work.
>> Does ipu3 need special userspace to work?
> 
> Yes, it will need further userspace support to configure the pipeline,
> and to provide 3A algorithms for white balance, focus, and exposure
> times to the sensor.
> 
> We are developing a stack called libcamera [0] to support this, but it's
> still in active development and not yet ready for use. Fortunately
> however, IPU3 is one of our primary initial targets.

Thanks for the info.

> 
> [0] https://www.libcamera.org/
> 
>> [1] https://bugs.launchpad.net/bugs/1812114
> 
> I have reported similar information to the launchpad bug entry.
> 
> It might help if we can get hold of a Dell 7275 sometime although I
> think Mauro at least has one ?
> 
> If this is a priority for Canonical, please contact us directly.

Not really, just raise issues from Launchpad to appropriate mailing list.

Kai-Heng

> 
>> Kai-Heng
> --
> Regards
> 
> Kieran

