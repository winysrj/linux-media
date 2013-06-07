Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1817 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3FGI1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 04:27:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Konke Radlow <koradlow@gmail.com>
Subject: Re: [RFC PATCHv2 0/3] libv4l2rds: add support for RDS-EON and TMC-tuning decoding
Date: Fri, 7 Jun 2013 10:27:12 +0200
Cc: linux-media@vger.kernel.org, hdegoede@redhat.com
References: <1370373303-6605-1-git-send-email-koradlow@gmail.com>
In-Reply-To: <1370373303-6605-1-git-send-email-koradlow@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306071027.12652.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Konke,

On Tue June 4 2013 21:15:00 Konke Radlow wrote:
> This patch series is based on the commments to:
> 
> [RFC PATCH 0/4] libv4l2rds: support for decoding RDS tuning information
> [RFC PATCH 1/4] libv4l2rds: added support to decode RDS-EON information
> [RFC PATCH 2/4] rds-ctl.cpp: added functionality to print RDS-EON information
> [RFC PATCH 3/4] libv4l2rds: added support to decode RDS-TMC tuning information
> [RFC PATCH 4/4] rds-ctl.cpp: added functionality to print RDS-TMC tuning information
> 
> The proposed changes have been integrated and the patches (1, 3) and (2, 4) have been merged
> into one unit.

Thank you for working on this. I've committed these patches. It's really nice
to have full support for this.

Regards,

	Hans
