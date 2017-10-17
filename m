Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50346 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756977AbdJQGau (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 02:30:50 -0400
Subject: Re: [GIT PULL FOR v4.15] Rockchip RGA driver
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jacob Chen <jacob-chen@iotwrt.com>,
        =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>
References: <a7c9c661-9820-7b45-c9fd-b1b7abd0b6eb@xs4all.nl>
 <ea109e0c-4b05-0721-8d7a-646696dd7efd@xs4all.nl>
Message-ID: <2e472b0b-212c-fc53-682b-162652bec9d2@xs4all.nl>
Date: Tue, 17 Oct 2017 08:30:44 +0200
MIME-Version: 1.0
In-Reply-To: <ea109e0c-4b05-0721-8d7a-646696dd7efd@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Heiko,

This driver was merged yesterday for 4.15, so you can go ahead and take the
dts patches.

Regards,

	Hans

On 10/13/2017 01:22 PM, Hans Verkuil wrote:
> On 10/13/17 13:20, Hans Verkuil wrote:
>> Hi Mauro,
>>
>> Here is the new Rockchip RGA driver.
> 
> Forgot to mention: Heiko will pick up the dts patches (not included in this
> pull request) once this is merged for 4.15.
> 
> Regards,
> 
> 	Hans
> 
>>
>> Regards,
>>
>> 	Hans
>>
>> The following changes since commit 8382e556b1a2f30c4bf866f021b33577a64f9ebf:
>>
>>   Simplify major/minor non-dynamic logic (2017-10-11 15:32:11 -0400)
>>
>> are available in the git repository at:
>>
>>   git://linuxtv.org/hverkuil/media_tree.git rga
>>
>> for you to fetch changes up to 90218215bd095b0fa53fa928e4ce40a5861474d3:
>>
>>   MAINTAINERS: add entry for Rockchip RGA driver (2017-10-13 12:30:01 +0200)
>>
>> ----------------------------------------------------------------
>> Jacob Chen (3):
>>       dt-bindings: Document the Rockchip RGA bindings
>>       rockchip/rga: v4l2 m2m support
>>       MAINTAINERS: add entry for Rockchip RGA driver
>>
>>  Documentation/devicetree/bindings/media/rockchip-rga.txt |   33 ++
>>  MAINTAINERS                                              |    7 +
>>  drivers/media/platform/Kconfig                           |   15 +
>>  drivers/media/platform/Makefile                          |    2 +
>>  drivers/media/platform/rockchip/rga/Makefile             |    3 +
>>  drivers/media/platform/rockchip/rga/rga-buf.c            |  154 ++++++++
>>  drivers/media/platform/rockchip/rga/rga-hw.c             |  421 +++++++++++++++++++++
>>  drivers/media/platform/rockchip/rga/rga-hw.h             |  437 ++++++++++++++++++++++
>>  drivers/media/platform/rockchip/rga/rga.c                | 1012 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/media/platform/rockchip/rga/rga.h                |  125 +++++++
>>  10 files changed, 2209 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt
>>  create mode 100644 drivers/media/platform/rockchip/rga/Makefile
>>  create mode 100644 drivers/media/platform/rockchip/rga/rga-buf.c
>>  create mode 100644 drivers/media/platform/rockchip/rga/rga-hw.c
>>  create mode 100644 drivers/media/platform/rockchip/rga/rga-hw.h
>>  create mode 100644 drivers/media/platform/rockchip/rga/rga.c
>>  create mode 100644 drivers/media/platform/rockchip/rga/rga.h
>>
> 
