Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web27701.mail.ukl.yahoo.com ([217.146.177.235])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <pongo_bob@yahoo.co.uk>) id 1LCvJ7-0007fr-1z
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 13:15:18 +0100
Date: Wed, 17 Dec 2008 12:14:43 +0000 (GMT)
From: Bob <pongo_bob@yahoo.co.uk>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <262721.56824.qm@web27701.mail.ukl.yahoo.com>
Subject: Re: [linux-dvb] Hauppauge Nova-TD-500 84xxx remote control
Reply-To: pongo_bob@yahoo.co.uk
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

Hi,
 I used the following kludge :

 The code for handling the remote is missing in linux/drivers/media/dvb/dvb-usb/dib0700_devices.c. Around line 1402 in you need to add 

			},
	        },

		.rc_interval      = DEFAULT_RC_INTERVAL,
		.rc_key_map       = dib0700_rc_keys,
		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
		.rc_query         = dib0700_rc_query

pinched from the remotes above.

This enables the remote if you recompile and reload the module you should see a new input device in dmesg, in my case I can cat /dev/input/event4 and see the key presses.

Unfortunately , the code in dib0700_rc_query always returns the last key pressed so you get an event every 150mS with the same key in it. So on to the next kludge :

At the top of dib0700_rc_query I added:

static int toggle;

and after i = dib0700_ctrl_rd( blah blah) :

if ( key[2] == toggle )
  return 0;
toggle = key[2];

This checks if the key fetched from the remote is the same as the last and returns if it is thus dumping all the repeats from dib0700_ctrl_rd;

Now you should find that UP , DOWN , LEFT and RIGHT keys work ok but not much else.

Kludge No.3 coming up :
Starting around line 612 in dib0700_devices.c are the key mappings for the Hauppauge remote. I changed the mapping for KEY_OK to KEY_ENTER so now I can navigate menus and select items.

And that is as far as I've got ..



      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
