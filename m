Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:38020 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755504AbdLORaW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 12:30:22 -0500
Subject: Re: [PATCH] [media] tda18212: fix use-after-free in tda18212_remove()
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
References: <20171215164337.3236-1-d.scheller.oss@gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <3c5e3614-ee61-f69a-283f-2c1b16aa2cbc@iki.fi>
Date: Fri, 15 Dec 2017 19:30:18 +0200
MIME-Version: 1.0
In-Reply-To: <20171215164337.3236-1-d.scheller.oss@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I think shared frontend structure, which is owned by demod driver, 
should be there and valid on time tuner driver is removed. And thus 
should not happen. Did you make driver unload on different order eg. not 
just reverse order than driver load?

IMHO these should go always

on load:
1) load demod driver (which makes shared frontend structure where also 
some tuner driver data lives)
2) load tuner driver
3) register frontend

on unload
1) unregister frontend
2) remove tuner driver
3) remove demod driver (frees shared data)


regards
Antti


On 12/15/2017 06:43 PM, Daniel Scheller wrote:
> From: Daniel Scheller <d.scheller@gmx.net>
> 
> When the driver gets unloaded via it's tda18212_remove() function, all
> frontend structures may already have been freed as controlling/bridge
> drivers already used dvb_frontend_detach() in their teardown process.
> Since __dvb_frontend_free now releases and clears all structures, the
> memset and the NULL assignment in tda18212_remove() leads to this KASAN
> report (invoked via ddbridge, which does dvb_frontend_detach() first,
> followed by i2c_unregister_device()):
> 
>    [  154.028353] ==================================================================
>    [  154.028396] BUG: KASAN: use-after-free in tda18212_remove+0x5c/0xb0 [tda18212]
>    [  154.028415] Write of size 288 at addr ffff880108b554d8 by task rmmod/285
> 
>    [  154.028442] CPU: 0 PID: 285 Comm: rmmod Tainted: G         C       4.15.0-rc1-13682-g1363f325bc44 #1
>    [  154.028444] Hardware name: Gigabyte Technology Co., Ltd. P35-DS3/P35-DS3, BIOS F3 06/11/2007
>    [  154.028445] Call Trace:
>    [  154.028452]  dump_stack+0x46/0x61
>    [  154.028458]  print_address_description+0x79/0x270
>    [  154.028462]  ? tda18212_remove+0x5c/0xb0 [tda18212]
>    [  154.028465]  kasan_report+0x229/0x340
>    [  154.028468]  memset+0x1f/0x40
>    [  154.028472]  tda18212_remove+0x5c/0xb0 [tda18212]
>    [  154.028476]  i2c_device_remove+0x97/0xe0
>    [  154.028481]  device_release_driver_internal+0x267/0x510
>    [  154.028484]  bus_remove_device+0x296/0x470
>    [  154.028486]  device_del+0x35c/0x890
>    [  154.028489]  ? __device_links_no_driver+0x1c0/0x1c0
>    [  154.028493]  ? cxd2841er_get_algo+0x10/0x10 [cxd2841er]
>    [  154.028497]  ? cxd2841er_get_algo+0x10/0x10 [cxd2841er]
>    [  154.028500]  ? __module_text_address+0xe/0x140
>    [  154.028503]  device_unregister+0x9/0x20
>    [  154.028509]  dvb_input_detach.isra.24+0x286/0x480 [ddbridge]
>    [  154.028514]  ddb_ports_detach+0x176/0x630 [ddbridge]
>    [  154.028519]  ddb_remove+0x3c/0xb0 [ddbridge]
>    [  154.028523]  pci_device_remove+0x93/0x1d0
>    [  154.028526]  device_release_driver_internal+0x267/0x510
>    [  154.028529]  driver_detach+0xb9/0x1b0
>    [  154.028532]  bus_remove_driver+0xd0/0x1f0
>    [  154.028536]  pci_unregister_driver+0x25/0x210
>    [  154.028541]  module_exit_ddbridge+0xc/0x45 [ddbridge]
>    [  154.028544]  SyS_delete_module+0x314/0x440
>    [  154.028546]  ? free_module+0x5b0/0x5b0
>    [  154.028550]  ? exit_to_usermode_loop+0xa9/0xc0
>    [  154.028552]  ? free_module+0x5b0/0x5b0
>    [  154.028554]  do_syscall_64+0x179/0x4c0
>    [  154.028557]  ? do_page_fault+0x1b/0x60
>    [  154.028560]  entry_SYSCALL64_slow_path+0x25/0x25
>    [  154.028563] RIP: 0033:0x7f6c40930de7
>    [  154.028565] RSP: 002b:00007ffc060d6ab8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
>    [  154.028569] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6c40930de7
>    [  154.028571] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000000002053268
>    [  154.028573] RBP: 0000000002053200 R08: 0000000000000000 R09: 1999999999999999
>    [  154.028574] R10: 0000000000000891 R11: 0000000000000206 R12: 00007ffc060d74ef
>    [  154.028576] R13: 0000000000000000 R14: 0000000002053200 R15: 0000000002052010
> 
>    [  154.028588] Allocated by task 164:
>    [  154.028603]  cxd2841er_attach+0xc3/0x7f0 [cxd2841er]
>    [  154.028608]  demod_attach_cxd28xx+0x14c/0x3f0 [ddbridge]
>    [  154.028612]  dvb_input_attach+0x671/0x1e20 [ddbridge]
>    [  154.028616]  ddb_ports_attach+0x453/0xd00 [ddbridge]
>    [  154.028620]  ddb_init+0x4b3/0xa30 [ddbridge]
>    [  154.028624]  ddb_probe+0xa51/0xfe0 [ddbridge]
>    [  154.028627]  pci_device_probe+0x279/0x480
>    [  154.028630]  driver_probe_device+0x46f/0x7a0
>    [  154.028632]  __driver_attach+0x133/0x170
>    [  154.028634]  bus_for_each_dev+0x10a/0x190
>    [  154.028637]  bus_add_driver+0x2a3/0x5a0
>    [  154.028639]  driver_register+0x182/0x3a0
>    [  154.028641]  0xffffffffa016808f
>    [  154.028643]  do_one_initcall+0x77/0x1d0
>    [  154.028646]  do_init_module+0x1c2/0x548
>    [  154.028648]  load_module+0x5e61/0x8df0
>    [  154.028650]  SyS_finit_module+0x142/0x150
>    [  154.028652]  do_syscall_64+0x179/0x4c0
>    [  154.028654]  return_from_SYSCALL_64+0x0/0x65
> 
>    [  154.028664] Freed by task 285:
>    [  154.028676]  kfree+0x6c/0xa0
>    [  154.028682]  __dvb_frontend_free+0x81/0xb0 [dvb_core]
>    [  154.028687]  dvb_input_detach.isra.24+0x17c/0x480 [ddbridge]
>    [  154.028691]  ddb_ports_detach+0x176/0x630 [ddbridge]
>    [  154.028695]  ddb_remove+0x3c/0xb0 [ddbridge]
>    [  154.028697]  pci_device_remove+0x93/0x1d0
>    [  154.028700]  device_release_driver_internal+0x267/0x510
>    [  154.028702]  driver_detach+0xb9/0x1b0
>    [  154.028705]  bus_remove_driver+0xd0/0x1f0
>    [  154.028707]  pci_unregister_driver+0x25/0x210
>    [  154.028711]  module_exit_ddbridge+0xc/0x45 [ddbridge]
>    [  154.028714]  SyS_delete_module+0x314/0x440
>    [  154.028716]  do_syscall_64+0x179/0x4c0
>    [  154.028718]  return_from_SYSCALL_64+0x0/0x65
> 
>    [  154.028729] The buggy address belongs to the object at ffff880108b55340
>                    which belongs to the cache kmalloc-2048 of size 2048
>    [  154.028755] The buggy address is located 408 bytes inside of
>                    2048-byte region [ffff880108b55340, ffff880108b55b40)
>    [  154.028778] The buggy address belongs to the page:
>    [  154.028792] page:ffffea00039e7a60 count:1 mapcount:0 mapping:ffff880108b54240 index:0x0 compound_mapcount: 0
>    [  154.028814] flags: 0x8000000000008100(slab|head)
>    [  154.028830] raw: 8000000000008100 ffff880108b54240 0000000000000000 0000000100000003
>    [  154.028848] raw: ffffea00039e7310 ffffea00039e7bd0 ffff88010b000800
>    [  154.028862] page dumped because: kasan: bad access detected
> 
>    [  154.028883] Memory state around the buggy address:
>    [  154.028896]  ffff880108b55380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>    [  154.028913]  ffff880108b55400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>    [  154.028929] >ffff880108b55480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>    [  154.028945]                                                     ^
>    [  154.028960]  ffff880108b55500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>    [  154.028976]  ffff880108b55580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>    [  154.028991] ==================================================================
>    [  154.029006] Disabling lock debugging due to kernel taint
> 
> Fix this by removing the memcpy and the NULL assign.
> 
> Cc: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>   drivers/media/tuners/tda18212.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
> index 7b8068354fea..ebccf8a8729d 100644
> --- a/drivers/media/tuners/tda18212.c
> +++ b/drivers/media/tuners/tda18212.c
> @@ -258,12 +258,7 @@ static int tda18212_probe(struct i2c_client *client,
>   static int tda18212_remove(struct i2c_client *client)
>   {
>   	struct tda18212_dev *dev = i2c_get_clientdata(client);
> -	struct dvb_frontend *fe = dev->cfg.fe;
>   
> -	dev_dbg(&client->dev, "\n");
> -
> -	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
> -	fe->tuner_priv = NULL;
>   	kfree(dev);
>   
>   	return 0;
> 

-- 
http://palosaari.fi/
