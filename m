Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35782
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752354AbcKNXl2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 18:41:28 -0500
Subject: Re: [PATCH 01/12] [media] rc-main: clear rc_map.name in
 ir_free_table()
To: Max Kellermann <max.kellermann@gmail.com>,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
Cc: linux-kernel@vger.kernel.org, shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <1b2a5353-d7c5-dd9c-3478-27825ec1f52a@osg.samsung.com>
Date: Mon, 14 Nov 2016 16:41:25 -0700
MIME-Version: 1.0
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/2016 03:32 PM, Max Kellermann wrote:
> rc_unregister_device() will first call ir_free_table(), and later
> device_del(); however, the latter causes a call to rc_dev_uevent(),
> which prints rc_map.name, which at this point has already bee freed.
> 
> This fixes a use-after-free bug found with KASAN.
> 
> Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
> ---
>  drivers/media/rc/rc-main.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 8e7f292..1e5a520 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -159,6 +159,7 @@ static void ir_free_table(struct rc_map *rc_map)
>  {
>  	rc_map->size = 0;
>  	kfree(rc_map->name);
> +	rc_map->name = NULL;
>  	kfree(rc_map->scan);
>  	rc_map->scan = NULL;
>  }
> 

Hi Mauro,

Could you please get this fix into 4.9. I am seeing the following when I do
rmmod on au0828

[  179.010878] ==================================================================
[  179.010895] BUG: KASAN: use-after-free in string+0x170/0x1f0 at addr ffff8801bd513000
[  179.010900] Read of size 1 by task rmmod/1831
[  179.010908] CPU: 1 PID: 1831 Comm: rmmod Tainted: G        W       4.9.0-rc5 #5
[  179.010910] Hardware name: Hewlett-Packard HP ProBook 6475b/180F, BIOS 68TTU Ver. F.04 08/03/2012
[  179.010914]  ffff8801aea2f680 ffffffff81b37ad3 ffff8801fa403b80 ffff8801bd513000
[  179.010922]  ffff8801aea2f6a8 ffffffff8156c301 ffff8801aea2f738 ffff8801bd513000
[  179.010930]  ffff8801fa403b80 ffff8801aea2f728 ffffffff8156c59a ffff8801aea2f770
[  179.010937] Call Trace:
[  179.010944]  [<ffffffff81b37ad3>] dump_stack+0x67/0x94
[  179.010950]  [<ffffffff8156c301>] kasan_object_err+0x21/0x70
[  179.010954]  [<ffffffff8156c59a>] kasan_report_error+0x1fa/0x4d0
[  179.010968]  [<ffffffffa116f05f>] ? au0828_exit+0x10/0x21 [au0828]
[  179.010973]  [<ffffffff8156c8b3>] __asan_report_load1_noabort+0x43/0x50
[  179.010978]  [<ffffffff81b58b20>] ? string+0x170/0x1f0
[  179.010982]  [<ffffffff81b58b20>] string+0x170/0x1f0
[  179.010987]  [<ffffffff81b621c4>] vsnprintf+0x374/0x1c50
[  179.010992]  [<ffffffff81b61e50>] ? pointer+0xa80/0xa80
[  179.010996]  [<ffffffff8156b676>] ? save_stack+0x46/0xd0
[  179.011001]  [<ffffffff81566faa>] ? __kmalloc+0x14a/0x2a0
[  179.011006]  [<ffffffff81b3d70a>] ? kobject_get_path+0x9a/0x200
[  179.011010]  [<ffffffff81b408c2>] ? kobject_uevent_env+0x282/0xca0
[  179.011014]  [<ffffffff81b412eb>] ? kobject_uevent+0xb/0x10
[  179.011020]  [<ffffffff81f10104>] ? device_del+0x434/0x6d0
[  179.011029]  [<ffffffffa0fea717>] ? rc_unregister_device+0x177/0x240 [rc_core]
[  179.011037]  [<ffffffffa116eeb0>] ? au0828_rc_unregister+0x60/0xb0 [au0828]

The problem is fixed with this patch on Linux 4.9-rc4

thanks,
-- Shuah
