Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KTi0w-00066W-5u
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 20:57:39 +0200
Received: by ug-out-1314.google.com with SMTP id x30so3512ugc.20
	for <linux-dvb@linuxtv.org>; Thu, 14 Aug 2008 11:57:34 -0700 (PDT)
Message-ID: <412bdbff0808141157t241748b4n5d82b15fcbc18d4a@mail.gmail.com>
Date: Thu, 14 Aug 2008 14:57:34 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Possible bug in dib0700_core.c i2c transfer function
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Sent this to Patrick Boettcher last week and didn't hear anything
back.  Figured it might be worth sending to the list to see if anyone
else had any ideas:

---

I have been doing some work on the Pinnacle PCTV HD Pro USB Stick,
which uses the dib0700/s5h1411/xc5000 combination.  I'm making good
progress but I think I might have run into a bug.

The dib0700_i2c_xfer() function appears to have a problem where it
converts i2c read calls into i2c write calls in certain cases.  In
particular, if you send a single i2c read message, the function always
treats it as a write request.

if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
 ...
} else {
 buf[0] = REQUEST_I2C_WRITE;
 ...

I would assume this would also fail if you sent multiple read messages
(read/read/read as opposed to write/read/write/read).

Was there some design limitation that prevents i2c read calls without
being preceded by a write call?  The dib0700_ctrl_rd() function only
seems to support a read in response to a write call.

The issue manifests itself in xc5000.c in the following case:

static int xc5000_readregs(struct xc5000_priv *priv, u8 *buf, u8 len)
{
 struct i2c_msg msg = { .addr = priv->cfg->i2c_address,
    .flags = I2C_M_RD, .buf = buf, .len = len };

 if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
   printk(KERN_ERR "xc5000 I2C read failed (len=%i)\n",(int)len);
   return -EREMOTEIO;
 }
 return 0;
}

I can probably work around it in the xc5000 driver, but this seems
like a pretty fundamental issue with i2c handing.  If this was a
limitation of the hardware design, it might make sense to at least
make the call fail in this case instead of turning it into a write
call.

If anyone has an experience with the dib0700 and has some insight as
to why it does this, I would appreciate it.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
