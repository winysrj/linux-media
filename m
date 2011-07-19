Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1GSKnC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 06:43:02 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6JAh2Ng027302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 06:43:02 -0400
Received: from shalem.localdomain (vpn1-6-8.ams2.redhat.com [10.36.6.8])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6JAh0sk005489
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 06:43:02 -0400
Message-ID: <4E25600F.6020500@redhat.com>
Date: Tue, 19 Jul 2011 12:44:31 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 3.1] pwc: Add support for control events
References: <4E255D71.8050906@redhat.com>
In-Reply-To: <4E255D71.8050906@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/19/2011 12:33 PM, Hans de Goede wrote:
> Hi Mauro,
>
> Please pull from my tree to add support for control events to
> the pwc driver. Note that this patch depends upon the patches
> from hverkuils poll tree (and those patches are thus also
> in my tree, but not part of this pull req).
>
> The following changes since commit 30178e8623281063c18592a848cdcd71f78f603d:
>
> vivi: let vb2_poll handle events. (2011-07-18 13:07:28 +0200)
>
> are available in the git repository at:
> git://linuxtv.org/hgoede/gspca.git media-for_v3.1
>
> Hans de Goede (1):
> pwc: Add support for control events
>

Self NACK, I just noticed that I got the release / unregister handling
wrong. Will re do and re-submit a pull req later.

Regards,

Hans
