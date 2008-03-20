Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47E1CC07.8050006@iki.fi>
Date: Thu, 20 Mar 2008 04:29:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47DBDB9F.5060107@iki.fi>	<abf3e5070803151642ub259f5bx18f067fc153cce89@mail.gmail.com>	<47DC64F4.9070403@iki.fi>
	<47DC6E0A.9000904@linuxtv.org>	<abf3e5070803151827s1f77d519o728f160126b28ac5@mail.gmail.com>	<47DC8012.3050809@linuxtv.org>	<abf3e5070803152025q14dd3e03tc8230940fe50e1b@mail.gmail.com>	<47DC93D0.3090904@linuxtv.org>
	<47DF2576.7080907@iki.fi>
	<abf3e5070803191901w14e4b827k8dd90fb202cafc6e@mail.gmail.com>
In-Reply-To: <abf3e5070803191901w14e4b827k8dd90fb202cafc6e@mail.gmail.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

Jarryd Beck wrote:
> On Tue, Mar 18, 2008 at 1:14 PM, Antti Palosaari <crope@iki.fi> wrote:
>> Michael Krufky wrote:
>>
>>> Jarryd Beck wrote:
>>  >> Takes half a minute to load when plugging in, keyboard is slow to respond
>>  >> when tuning, and I get lots of this:
>>  >>
>>  >> af9013_i2c_gate_ctrl: enable:0
>>  >> af9013_i2c_gate_ctrl: enable:1
>>  >>
>>  >> Applied the patch again and it was all fine.
>>  >>
>>  >> Jarryd.
>>  >>
>>  > Thanks for the test, Jarryd.  I will integrate this into the official
>>  > tda18271 driver after testing again on my hardware here.  I will
>>  > probably make it an attach-time configurable option.
>>  >
>>  > Regards,
>>  >
>>  > Mike
>>
>>  I did some fixes and I think driver should be now ready. I also changed
>>  again device plug / fw-download / usb-relink scheme. I put 500ms sleep
>>  to indentify_state in hope that it is enough to drop ghost device driver
>>  after fw is downloaded and stick reconnects.
>>
>>  However I tested I2C-writing with my MT2060 tuner based device by adding
>>  about ~50 register write at once and it did not make any harm.
>>  Anyhow, there is now versions to test:
>>
>>  version without tuner small-i2c limit:
>>
>> http://linuxtv.org/hg/~anttip/af9015_new/
>>
>>  version with tuner small-i2c limit:
>>  http://linuxtv.org/hg/~anttip/af9015_new2/
>>
>>  Regards
>>  Antti
>>  --
>>  http://palosaari.fi/
>>
> 
> Sorry about the time I took, I had a lot of uni work.
> The second one worked, the first didn't.
> 
> Jarryd.

Thanks, I removed obsolete trees.
Shall I ask two more questions;
Did stick plug work now without no_reconnect or any other modifications 
(probably yes)?
How about lock LED? I tried to look sniffs but did not see straight 
answer why it did not work for you. Anyhow, I did small change that 
could affect it.
If you want to play it you can try to change line from frontend/af9013.c
return af9013_write_reg_bits(state, 0xd730, 0, 1, onoff);
to
return af9013_write_reg_bits(state, 0xd730, 1, 1, onoff);
or 2 or 3 to see if it helps.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
