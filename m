Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:64548 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab0BKGyN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 01:54:13 -0500
Received: by mail-pz0-f172.google.com with SMTP id 2so198285pzk.21
        for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 22:54:12 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, zyziii@telegent.com,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 2/2] modify the document
Date: Thu, 11 Feb 2010 14:53:52 +0800
Message-Id: <1265871232-2144-2-git-send-email-shijie8@gmail.com>
In-Reply-To: <1265871232-2144-1-git-send-email-shijie8@gmail.com>
References: <1265871232-2144-1-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

remove the the country code section.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 Documentation/video4linux/README.tlg2300 |  198 +----------------------------
 1 files changed, 7 insertions(+), 191 deletions(-)

diff --git a/Documentation/video4linux/README.tlg2300 b/Documentation/video4linux/README.tlg2300
index 82417db..416ccb9 100644
--- a/Documentation/video4linux/README.tlg2300
+++ b/Documentation/video4linux/README.tlg2300
@@ -37,195 +37,11 @@ TESTED APPLICATIONS:
 
 ---------------------------------------------------------------------------
 KNOWN PROBLEMS:
+about preemphasis:
+	You can set the preemphasis for radio by the following command:
+	#v4l2-ctl -d /dev/radio0 --set-ctrl=pre_emphasis_settings=1
+
+	"pre_emphasis_settings=1" means that you select the 50us. If you want
+	to select the 75us, please use "pre_emphasis_settings=2"
+
 
-country code
-	- The firmware of the chip needs the country code to determine
-	the stardards of video and audio when it runs for analog TV or radio.
-	The DVB-T does not need the country code.
-
-	So you must set the country-code correctly. The V4L2 does not have
-	the interface,the driver has to provide a parameter `country_code'.
-
-	You could set the coutry code in two ways, take USA as example
-	(The USA's country code is 1):
-
-	[1] add the following line in /etc/modprobe.conf before you insert the
-	    card into USB hub's port :
-		poseidon country_code=1
-
-	[2] You can also modify the parameter at runtime (before you run the
-	    application such as VLC)
-		#echo 1 > /sys/module/poseidon/parameter/country_code
-
-	The known country codes show below:
-	country code :  country
-	93 		"Afghanistan"
-	355	 	"Albania"
-	213	 	"Algeria"
-	684	 	"American Samoa"
-	376	 	"Andorra"
-	244	 	"Angola"
-	54 		"Argentina"
-	374	 	"Armenia"
-	61 		"Australia"
-	43 		"Austria"
-	994	 	"Azerbaijan"
-	973	 	"Bahrain"
-	880	 	"Bangladesh"
-	375	 	"Belarus"
-	32 		"Belgium"
-	501	 	"Belize"
-	229	 	"Benin"
-	591	 	"Bolivia"
-	387	 	"Bosnia and Herzegovina"
-	267	 	"Botswana"
-	55 		"Brazil"
-	673	 	"Brunei Darussalam"
-	359	 	"Bulgalia"
-	226	 	"Burkina Faso"
-	257	 	"Burundi"
-	237	 	"Cameroon"
-	1		"Canada"
-	236	 	"Central African Republic"
-	235	 	"Chad"
-	56 		"Chile"
-	86 		"China"
-	57 		"Colombia"
-	242	 	"Congo"
-	243	 	"Congo, Dem. Rep. of "
-	506	 	"Costa Rica"
-	385	 	"Croatia"
-	53 		"Cuba or Guantanamo Bay"
-	357	 	"Cyprus"
-	420	 	"Czech Republic"
-	45 		"Denmark"
-	246	 	"Diego Garcia"
-	253	 	"Djibouti"
-	593	 	"Ecuador"
-	20 		"Egypt"
-	503	 	"El Salvador"
-	240	 	"Equatorial Guinea"
-	372	 	"Estonia"
-	251	 	"Ethiopia"
-	358	 	"Finland"
-	33 		"France"
-	594	 	"French Guiana"
-	689	 	"French Polynesia"
-	241	 	"Gabonese Republic"
-	220	 	"Gambia"
-	995	 	"Georgia"
-	49 		"Germany"
-	233	 	"Ghana"
-	350	 	"Gibraltar"
-	30 		"Greece"
-	299	 	"Greenland"
-	671	 	"Guam"
-	502		"Guatemala"
-	592	 	"Guyana"
-	509	 	"Haiti"
-	504	 	"Honduras"
-	852	 	"Hong Kong SAR, China"
-	36 		"Hungary"
-	354	 	"Iceland"
-	91 		"India"
-	98 		"Iran"
-	964	 	"Iraq"
-	353	 	"Ireland"
-	972	 	"Israel"
-	39 		"Italy or Vatican City"
-	225	 	"Ivory Coast"
-	81 		"Japan"
-	962	 	"Jordan"
-	7		"Kazakhstan or Kyrgyzstan"
-	254	 	"Kenya"
-	686	 	"Kiribati"
-	965	 	"Kuwait"
-	856	 	"Laos"
-	371	 	"Latvia"
-	961	 	"Lebanon"
-	266	 	"Lesotho"
-	231	 	"Liberia"
-	218	 	"Libya"
-	41 		"Liechtenstein or Switzerland"
-	370	 	"Lithuania"
-	352	 	"Luxembourg"
-	853	 	"Macau SAR, China"
-	261	 	"Madagascar"
-	60 		"Malaysia"
-	960	 	"Maldives"
-	223	 	"Mali Republic"
-	356	 	"Malta"
-	692	 	"Marshall Islands"
-	596	 	"Martinique"
-	222	 	"Mauritania"
-	230	 	"Mauritus"
-	52 		"Mexico"
-	691	 	"Micronesia"
-	373	 	"Moldova"
-	377	 	"Monaco"
-	976	 	"Mongolia"
-	212	 	"Morocco"
-	258	 	"Mozambique"
-	95 		"Myanmar"
-	264	 	"Namibia"
-	674	 	"Nauru"
-	31 		"Netherlands"
-	687	 	"New Caledonia"
-	64 		"New Zealand"
-	505	 	"Nicaragua"
-	227	 	"Niger"
-	234	 	"Nigeria"
-	850	 	"North Korea"
-	47 		"Norway"
-	968	 	"Oman"
-	92 		"Pakistan"
-	680	 	"Palau"
-	507	 	"Panama"
-	675	 	"Papua New Guinea"
-	595	 	"Paraguay"
-	51 		"Peru"
-	63 		"Philippines"
-	48 		"Poland"
-	351	 	"Portugal"
-	974	 	"Qatar"
-	262	 	"Reunion Island"
-	40 		"Romania"
-	7		"Russia"
-	378	 	"San Marino"
-	239	 	"Sao Tome and Principe"
-	966	 	"Saudi Arabia"
-	221	 	"Senegal"
-	248	 	"Seychelles Republic"
-	232	 	"Sierra Leone"
-	65 		"Singapore"
-	421	 	"Slovak Republic"
-	386	 	"Slovenia"
-	27 		"South Africa"
-	82 		"South Korea "
-	34 		"Spain"
-	94 		"Sri Lanka"
-	508	 	"St. Pierre and Miquelon"
-	249	 	"Sudan"
-	597	 	"Suriname"
-	268	 	"Swaziland"
-	46 		"Sweden"
-	963	 	"Syria"
-	886	 	"Taiwan Region"
-	255	 	"Tanzania"
-	66 		"Thailand"
-	228	 	"Togolese Republic"
-	216	 	"Tunisia"
-	90 		"Turkey"
-	993	 	"Turkmenistan"
-	256	 	"Uganda"
-	380	 	"Ukraine"
-	971	 	"United Arab Emirates"
-	44 		"United Kingdom"
-	1		"United States of America"
-	598	 	"Uruguay"
-	58 		"Venezuela"
-	84 		"Vietnam"
-	967	 	"Yemen"
-	260	 	"Zambia"
-	255	 	"Zanzibar"
-	263	 	"Zimbabwe"
-- 
1.6.5.2

