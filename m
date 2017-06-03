Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58939 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdFCDKt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 23:10:49 -0400
Subject: Re: [media] vimc: API proposal, configuring the topology from user
 space
To: linux-media@vger.kernel.org
References: <b88b916e-97ee-f91d-368f-bc0793fe5c0d@collabora.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jeremy Gebben <jgebben@codeaurora.org>,
        linux-kernel@vger.kernel.org
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <409c3a46-abbc-0ba4-1ee9-ab73ae8e321d@collabora.com>
Date: Sat, 3 Jun 2017 00:10:33 -0300
MIME-Version: 1.0
In-Reply-To: <b88b916e-97ee-f91d-368f-bc0793fe5c0d@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ping

On 2017-04-10 07:53 PM, Helen Koike wrote:
>
> Hi,
>
> Continuing the discussion about the API of the vimc driver, I made some
> changes
> based on the previous comments, please see below and let me know your
> opinion about it.
>
> Helen
>
> /***********************
> Configfs considerations:
> ************************/
> Informal definitions:
>     subsystem: the root driver folder in user space (/configfs/vimc)
>     item: aka a folder in user space
>     attributes: aka files in the folder
>     group: aka a folder that can contain subfolders (parent and child
> relation)
>     default group: aka a subfolder that is created automatically when
> the "parent" folder is created
>         it is not considered a child in terms of rmdir
>
> * Performing rmdir in a group will fail if it contain children that are
> not default groups, i.e, if the
> folder contain subfolders that are default group, then it can be removed
> with rmdir, if the
> subfolders were created with mkdir, then rmdir in the parent will fail.
>
> * Configfs has the notion of committable item but it is not implemented
> yet. A committable item is an item
> that can be in one of two parent folders called: live and pending. The
> idea is to create and modify the item
> in the pending directory and then to move the item through a rename to
> the live directory where
> it can't be modified. This seems to be a nice feature for vimc, but as
> it is not available yet the
> proposal below won't be based on this.
>
> * Groups can be dynamically created/destroyed by the driver whenever it
> wants. Afaik attributes can only
> be created when the group or item is created and symlinks can only be
> create from user space, i.e, the
> driver don't know how to create/destroy attributes or symlinks in anytime.
>
> /***********************
> The API:
> ************************/
>
> In short, a topology like this one: http://goo.gl/Y7eUfu
> Would look like this filesystem tree: https://goo.gl/mEOmOf
>
> v3 core changes:
> - I removed the use of symlinks as I wans't able to see how to do it
> nicely.
> - I use the names of the folders created by user space to retrieve
> information at mkdir time
> - hotplug file in each entity
> - hotplug file in each device
> - reset file in each device
>
> * The /configfs/vimc subsystem
> empty when the driver is loaded
>
> * Create a device
> Userspace can create a new vimc device with:
>
>     $ mkdir /configfs/vimc/any_name
>     Example:
>     $ mkdir /configfs/vimc/vimc0
>     $ ls -l /configfs/vimc/vimc0
>     hotplug
>     reset
>     entities/
>     links/
>
> entities/ and links/ folder are default groups, thus they don't prevent
> rmdir vimc0/, but
> rmdir will fail if it has any child inside entities/ or links/.
> hotplug is used to plug and unplug the device, it can read "plugged" or
> "unplugged" and user can
> write "plug" or "unplug" to change its state.
> Changing hotplug state will never fail as the configfs tree will always
> be in a valid state.
> reset is used to easily destroy all the topology without the need to
> walk through all the children
> to perform rmdir, writing 1 to reset file will set hotplug to
> "unplugged" and erase all folders
> under entities/ and links/.
>
> * Create an entity
> Userspace can create a new entity with:
>
>     $ mkdir /configfs/vimc/vimc0/entities/<role>:<name>
>     Example:
>     $ mkdir /configfs/vimc/vimc0/entities/sensor:SensorA
>     $ ls -l /configfs/vimc/vimc0/entities/sensor:SensorA
>     hotplug
>     pad:source:0/
>
> The name of the folder needs to be in the format <role>:<name> or it
> will be rejected, this allows the
> creation of the right pads according to its role at mkdir time,
> eliminating the previously proposed role
> and name files.
> hotplug is used to plug and unplug the hw block, it can read "plugged"
> or "unplugged" and user can
> write "plug" or "unplug" to change its state. As we don't support this
> yet in the media core, changing it
> will only be allowed if /configfs/vimc/vimc0/hotplug is "unplugged".
> hotplug file is "unplugged" by default.
> Pads will be created as default groups with the name in the format
> pad:<direction>:<pad_number> and it
> will be an empty folder.
> If the hw block supports different number of pads, we could expose two
> files:
> sinks
> sources
> where the user space can write the desired number of sink and source
> pads and the driver will dynamically
> create the folders pad:<direction>:<pad_number>
>
> * Create a link
> User space can create a link between two entities with:
>
>     $ mkdir
> /configfs/vimc/vimc0/links/<entity_src_name>:<pad_n>-><entity_sink_name>:<pad_n>
>
>     Example:
>     $ mkdir /configfs/vimc/vimc0/links/DebayerA:1->Scaler:0
>     $ ls -l /configfs/vimc/vimc0/links/DebayerA:1->Scaler:0
>     flags
>
> mkdir will be rejected if folder is not on the format
> <entity_src_name>:<pad_n>-><entity_sink_name>:<pad_n>.
> mkdir will be rejected if either <entity_src_name> or <entity_sink_name>
> are not found in /configfs/vimc/vimc0/entities/
> The link will only be created if both entities are in "plugged" state.
> When an entity is removed from /configfs/vimc/vimc0/entities/ with
> rmdir, its corresponding link folders at
> /configfs/vimc/vimc0/links will be automatically removed.
> If one of the entities changes from "plugged" to "unplugged", the link
> is only removed from the media
> representation, the link folder won't be removed.
> flags can be one of "", "enabled", "immutable", "dynamic",
> "dynamic,enabled".
> flags cannot be changed if the link was already created in the media
> controller, to alter it unplug the
> device through /configfs/vimc/vimc0/hotplug or unplug one of the source
> or sink entities connected to the
> link through its hotplug file.
> flags are of type "" by default.
