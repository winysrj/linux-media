Return-path: <mchehab@pedra>
Received: from canardo.mork.no ([148.122.252.1]:55881 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab1FCNUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 09:20:18 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Antti Palosaari <crope@iki.fi>
Cc: Steve Kerrison <steve@stevekerrison.com>,
	linux-media@vger.kernel.org
Subject: Re: [bug-report] unconditionally calling cxd2820r_get_tuner_i2c_adapter() from em28xx-dvb.c creates a hard module dependency
References: <87vcwpnavc.fsf@nemi.mork.no> <4DE60B36.9040507@iki.fi>
	<87mxi1n7ql.fsf@nemi.mork.no> <87tyc9lbb1.fsf@nemi.mork.no>
	<4DE8D1E6.4000300@iki.fi> <87hb87xeni.fsf@nemi.mork.no>
	<4DE8DA9F.8050706@iki.fi>
Date: Fri, 03 Jun 2011 15:20:10 +0200
In-Reply-To: <4DE8DA9F.8050706@iki.fi> (Antti Palosaari's message of "Fri, 03
	Jun 2011 15:59:11 +0300")
Message-ID: <87aadzxd9x.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Antti Palosaari <crope@iki.fi> writes:
> On 06/03/2011 03:50 PM, Bjørn Mork wrote:
>
>> This probably means that a generic i2c_tuner wrapper, similar to
>> dvb_attach, would be useful.
>
> For the cxd2820r it is also possible to return I2C adapter as pointer
> from dvb_attach like pointer to FE0 is carried for FE1
> dvb_attach. What you think about that?

I don't feel competent to answer that at all.  It does seem like
overloading an existing interface, but it might be OK.

I just grepped a bit around for EXPORT_SYMBOL of anything except
foo_attach, and found that there are a few frontend drivers which
exports multiple symbols:

bjorn@canardo:/usr/local/src/git/linux-2.6$ grep EXPORT_SYMBOL drivers/media/dvb/frontends/*.c|grep -v _attach
drivers/media/dvb/frontends/cx24113.c:EXPORT_SYMBOL(cx24113_agc_callback);
drivers/media/dvb/frontends/cx24123.c:EXPORT_SYMBOL(cx24123_get_tuner_i2c_adapter);
drivers/media/dvb/frontends/cxd2820r_core.c:EXPORT_SYMBOL(cxd2820r_get_tuner_i2c_adapter);
drivers/media/dvb/frontends/dib0070.c:EXPORT_SYMBOL(dib0070_ctrl_agc_filter);
drivers/media/dvb/frontends/dib0070.c:EXPORT_SYMBOL(dib0070_get_rf_output);
drivers/media/dvb/frontends/dib0070.c:EXPORT_SYMBOL(dib0070_set_rf_output);
drivers/media/dvb/frontends/dib0070.c:EXPORT_SYMBOL(dib0070_wbd_offset);
drivers/media/dvb/frontends/dib0090.c:EXPORT_SYMBOL(dib0090_dcc_freq);
drivers/media/dvb/frontends/dib0090.c:EXPORT_SYMBOL(dib0090_pwm_gain_reset);
drivers/media/dvb/frontends/dib0090.c:EXPORT_SYMBOL(dib0090_gain_control);
drivers/media/dvb/frontends/dib0090.c:EXPORT_SYMBOL(dib0090_get_current_gain);
drivers/media/dvb/frontends/dib0090.c:EXPORT_SYMBOL(dib0090_get_wbd_offset);
drivers/media/dvb/frontends/dib0090.c:EXPORT_SYMBOL(dib0090_get_tune_state);
drivers/media/dvb/frontends/dib0090.c:EXPORT_SYMBOL(dib0090_set_tune_state);
drivers/media/dvb/frontends/dib0090.c:EXPORT_SYMBOL(dib0090_register);
drivers/media/dvb/frontends/dib0090.c:EXPORT_SYMBOL(dib0090_fw_register);
drivers/media/dvb/frontends/dib3000mc.c:EXPORT_SYMBOL(dib3000mc_get_tuner_i2c_master);
drivers/media/dvb/frontends/dib3000mc.c:EXPORT_SYMBOL(dib3000mc_pid_control);
drivers/media/dvb/frontends/dib3000mc.c:EXPORT_SYMBOL(dib3000mc_pid_parse);
drivers/media/dvb/frontends/dib3000mc.c:EXPORT_SYMBOL(dib3000mc_set_config);
drivers/media/dvb/frontends/dib3000mc.c:EXPORT_SYMBOL(dib3000mc_i2c_enumeration);
drivers/media/dvb/frontends/dib7000m.c:EXPORT_SYMBOL(dib7000m_get_i2c_master);
drivers/media/dvb/frontends/dib7000m.c:EXPORT_SYMBOL(dib7000m_pid_filter_ctrl);
drivers/media/dvb/frontends/dib7000m.c:EXPORT_SYMBOL(dib7000m_pid_filter);
drivers/media/dvb/frontends/dib7000m.c:EXPORT_SYMBOL(dib7000m_i2c_enumeration);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7000p_set_wbd_ref);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7000p_update_pll);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7000p_set_gpio);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7000p_ctrl_timf);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7000pc_detection);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7000p_get_i2c_master);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7000p_pid_filter_ctrl);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7000p_pid_filter);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7000p_i2c_enumeration);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7090_get_i2c_tuner);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7090_tuner_sleep);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7090_agc_restart);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7090_get_adc_power);
drivers/media/dvb/frontends/dib7000p.c:EXPORT_SYMBOL(dib7090_slave_reset);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_set_wbd_ref);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_set_gpio);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_pwm_agc_reset);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_get_adc_power);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_get_tune_state);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_set_tune_state);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_set_slave_frontend);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_remove_slave_frontend);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_get_slave_frontend);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_i2c_enumeration);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_get_i2c_master);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_pid_filter_ctrl);
drivers/media/dvb/frontends/dib8000.c:EXPORT_SYMBOL(dib8000_pid_filter);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_fw_set_component_bus_speed);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_get_tuner_interface);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_get_component_bus_interface);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_get_i2c_master);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_set_i2c_adapter);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_set_gpio);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_fw_pid_filter_ctrl);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_fw_pid_filter);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_firmware_post_pll_init);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_i2c_enumeration);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_set_slave_frontend);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_remove_slave_frontend);
drivers/media/dvb/frontends/dib9000.c:EXPORT_SYMBOL(dib9000_get_slave_frontend);
drivers/media/dvb/frontends/dibx000_common.c:EXPORT_SYMBOL(dibx000_i2c_set_speed);
drivers/media/dvb/frontends/dibx000_common.c:EXPORT_SYMBOL(dibx000_get_i2c_adapter);
drivers/media/dvb/frontends/dibx000_common.c:EXPORT_SYMBOL(dibx000_reset_i2c_master);
drivers/media/dvb/frontends/dibx000_common.c:EXPORT_SYMBOL(dibx000_init_i2c_master);
drivers/media/dvb/frontends/dibx000_common.c:EXPORT_SYMBOL(dibx000_exit_i2c_master);
drivers/media/dvb/frontends/dibx000_common.c:EXPORT_SYMBOL(systime);
drivers/media/dvb/frontends/drxd_hard.c:EXPORT_SYMBOL(drxd_config_i2c);
drivers/media/dvb/frontends/s5h1420.c:EXPORT_SYMBOL(s5h1420_get_tuner_i2c_adapter);
drivers/media/dvb/frontends/stv090x.c:EXPORT_SYMBOL(stv090x_set_gpio);


Which does show up as hard dependencies on your typical Debian
installation (which does set CONFIG_MEDIA_ATTACH):

 bjorn@nemi:~$ modinfo -F depends dvb-usb-dib0700
 dib8000,dvb-usb,i2c-core,dib0070,dib3000mc,usbcore,dib7000p,dib7000m


So it looks like this problem is much more widespread than I initially
thought, and it may therefore be perfectly OK to do what you did.
However, the em28xx-dvb driver can be used with a large number of
frontends and we certainly don't want them all as hard dependencies.


I think it's time for someone with authority to state what is acceptable
and what is not, with regard to frontends, tuners, dvb_attach(),
EXPORT_SYMBOL and CONFIG_MEDIA_ATTACH. 

For all I know, this may already be documented somewhere.  If so, please
point me there.



Bjørn
