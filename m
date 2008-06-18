Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5I2CaWi009677
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 22:12:36 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au
	(outbound.icp-qv1-irony-out3.iinet.net.au [203.59.1.148])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5I2COod020916
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 22:12:25 -0400
Message-ID: <48586F09.7020700@iinet.net.au>
Date: Wed, 18 Jun 2008 10:12:25 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: Allen <lists@iisys.com.au>, linux-dvb@linuxtv.org,
	video4linux-list@redhat.com, hermann pitton <hermann-pitton@arcor.de>
References: <1204893775.10536.4.camel@ubuntu> <47D1A65B.3080900@t-online.de>	
	<1205480517.5913.8.camel@ubuntu> <47DEE11F.6060301@t-online.de>	
	<1205851252.11231.7.camel@ubuntu>
	<1213744559.11684.4.camel@asus.lounge>
In-Reply-To: <1213744559.11684.4.camel@asus.lounge>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Allen wrote:
> Tim,
>
> I was just sorting through some old emails from linuxtv archive, and
> came across
>
>   
>> PS. I've actually managed to get the remote to work through a very
>> convoluted approach via the archives (Hermann), using ir-kbd-i2c.c,
>> saa7134-i2c.c. But it's no use unless we can fix this tuning/scanning
>> issue.
>>     
>
> I have a kw 220rf which I think might be very similar.  
>
> Despite repeated attempts to get the remote working, I have never been
> able to get it to respond in any fashion.  Could you please describe how
> you got it to function, and any problems with operation.
>
> Thanks,
>
> Allen
>
>   
Hi Steve,
Please cc to these mail lists so others can be helpful to you, as well.
You will find Hermann has some answers for saa7134 i2c remotes.
I will paste here my mods, so that others may be able to help get it
going.

This code is an adaptation of originally Henry Wong's work,
and much further work by numerous people across the planet.
Until recently this modification enabled a working remote control
for the Kworld 210RF.
This card has a KS007 remote controller chip.

Since that time, the i2c code in v4l-dvb has undergone a
substantial transition.

Thus this code no longer works, in particular, within ir-kbd-i2c.c
This is the only success I have ever had in getting an i2c
remote control to work in saa7134.

As I have had a few problems with this card working properly,
I basically lost interest.

Perhaps others with a Kworld 210RF or a Kworld 220RF card
can get it working again.

***************************************************************
Mods to /v4l-dvb/linux/include/media/ir-common.h

extern IR_KEYTAB_TYPE ir_codes_kworld_210[IR_KEYTAB_SIZE];
***************************************************************
Mods to /v4l-dvb/linux/drivers/media/common/ir-keymaps.c

IR_KEYTAB_TYPE ir_codes_kworld_210[IR_KEYTAB_SIZE] = {
    [ 0x00 ] = KEY_1,
    [ 0x01 ] = KEY_2,
    [ 0x02 ] = KEY_3,
    [ 0x03 ] = KEY_4,
    [ 0x04 ] = KEY_5,
    [ 0x05 ] = KEY_6,
    [ 0x06 ] = KEY_7,
    [ 0x07 ] = KEY_8,
    [ 0x08 ] = KEY_9,
    [ 0x09 ] = KEY_BACKSPACE,
    [ 0x0a ] = KEY_0,
    [ 0x0b ] = KEY_ENTER,
    [ 0x0c ] = KEY_POWER,
    [ 0x0d ] = KEY_SUBTITLE,
    [ 0x0e ] = KEY_VIDEO,
    [ 0x0f ] = KEY_CAMERA,
    [ 0x10 ] = KEY_CHANNELUP,
    [ 0x11 ] = KEY_CHANNELDOWN,
    [ 0x12 ] = KEY_VOLUMEDOWN,
    [ 0x13 ] = KEY_VOLUMEUP,
    [ 0x14 ] = KEY_MUTE,
    [ 0x15 ] = KEY_AUDIO,
    [ 0x16 ] = KEY_TV,
    [ 0x17 ] = KEY_ZOOM,
    [ 0x18 ] = KEY_PRINT,
    [ 0x19 ] = KEY_SETUP,
    [ 0x1a ] = KEY_STOP,
    [ 0x1b ] = KEY_RECORD,
    [ 0x1c ] = KEY_TEXT,
    [ 0x1d ] = KEY_REWIND,
    [ 0x1e ] = KEY_FASTFORWARD,
    [ 0x1f ] = KEY_SHUFFLE,
    [ 0x45 ] = KEY_STOP,
    [ 0x44 ] = KEY_PLAY,
};
EXPORT_SYMBOL_GPL(ir_codes_kworld_210);
***************************************************************
Mods to /v4l-dvb/linux/drivers/media/video/saa7134/saa7134-i2c.c
...
    /* Am I an i2c remote control? */

    switch (client->addr) {
        case 0x7a:
        case 0x47:
        case 0x71:
        case 0x2d:
        case 0x30: /*for kw210 remote control*/
        {
...

static char *i2c_devs[128] = {
    [ 0x20      ] = "mpeg encoder (saa6752hs)",
    [ 0xa0 >> 1 ] = "eeprom",
    [ 0xc0 >> 1 ] = "tuner (analog)",
    [ 0x86 >> 1 ] = "tda9887",
    [ 0x5a >> 1 ] = "remote control",
    [ 0x30      ] = "kw210 remote control",
};
...
***************************************************************
Mods to /v4l-dvb/linux/drivers/media/video/ir-kbd-i2c.c
...

static int get_key_kworld_210(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
{
    unsigned char b;

    /* poll IR chip */
    if (1 != i2c_master_recv(&ir->c,&b,1)) {
        dprintk(1,"read error\n");
        return -EIO;
    }

    /* it seems that 0x80 indicates that a button is still hold
       down, while 0xff indicates that no button is hold
       down. 0x80 sequences are sometimes interrupted by 0xFF */

    dprintk(2,"key %02x\n", b);

    if (b == 0xff)
        return 0;

    if (b == 0x80)
        /* keep old data */
        return 1;

    *ir_key = b;
    *ir_raw = b;
    return 1;
}
...
/*Unless the timer is modified, you have time to make a cup of tea while 
waiting
* for a response after pressing a key
*/
static int polling_interval = 100; /* ms */
...
static void ir_timer(unsigned long data)
{
    struct IR_i2c *ir = (struct IR_i2c*)data;
    schedule_work(&ir->work);
}
...
static void ir_work(struct work_struct *work)
#endif
{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
    struct IR_i2c *ir = data;
#else
    struct IR_i2c *ir = container_of(work, struct IR_i2c, work);
#endif

    ir_key_poll(ir);
    /*kw210 improve key-response time*/
    mod_timer(&ir->timer, jiffies + polling_interval*HZ/1000);
}
...
/*needed to select between cards with same i2c address for remote 
controller*/
static int kWorld_210 = 0;
...
    case 0x30:
        ir_type     = IR_TYPE_OTHER;
/*add kw210 card*/
        if (kWorld_210 == 1) {
            name        = "kWoRlD210";
            ir->get_key = get_key_kworld_210;
            ir_codes    = ir_codes_kworld_210;
        } else {
            name        = "KNC One";
            ir->get_key = get_key_knc1;
            ir_codes    = ir_codes_empty;
        } 
        break;
...
static int ir_probe(struct i2c_adapter *adap)
{
...

    static const int probe_bttv[] = { 0x1a, 0x18, 0x4b, 0x64, 0x30, -1};
/*add 0x30*/
    static const int probe_saa7134[] = { 0x7a, 0x47, 0x71, 0x2d, 0x30, -1 };
...
    c->adapter = adap;
    for (i = 0; -1 != probe[i]; i++) {
        c->addr = probe[i];
        rc = i2c_master_recv(c, &buf, 0);
/*mod added here to "wake up" kw210 remote controller chip*/
        if (adap->id == I2C_HW_SAA7134 && probe[i] == 0x30)
        {
            struct i2c_client c2;
            memset (&c2, 0, sizeof(c2));
            c2.adapter = adap;   
            for (c2.addr=127; c2.addr > 0; c2.addr--) {
                if (0 == i2c_master_recv(&c2,&buf,0)) {
                    dprintk(1,"Found another device, at addr 0x%02x\n", 
c2.addr);
                    break;
                }
            }

            /* Now do the probe. The controller does not respond
               to 0-byte reads, so we use a 1-byte read instead. */
            rc = i2c_master_recv(c,&buf,1);
            rc--;
            kWorld_210 = 1;
        } else {
            rc = i2c_master_recv(c,&buf,0);
        }
        dprintk(1,"probe 0x%02x @ %s: %s\n",
            probe[i], adap->name,
            (0 == rc) ? "yes" : "no");
        if (0 == rc) {
            ir_attach(adap, probe[i], 0, 0);
            break;
        }
    }
    kfree(c);
    return 0;
}
***************************************************************

Regards,
Timf

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
