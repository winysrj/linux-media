Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933243Ab3CSQum (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:42 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/46] [media] siano: better debug send/receive messages
Date: Tue, 19 Mar 2013 13:48:54 -0300
Message-Id: <1363711775-2120-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of printing a message for some random messages, print
it for all sent/received ones. That helps a lot to debug
what's going on.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 351 +++++++++++++++++++++++++++++++-
 drivers/media/common/siano/smscoreapi.h |   2 +
 drivers/media/common/siano/smsdvb.c     |  10 +-
 drivers/media/usb/siano/smsusb.c        |   9 +
 4 files changed, 354 insertions(+), 18 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 58371c3..4c83d3c 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -63,6 +63,345 @@ struct smscore_client_t {
 	onremove_t		onremove_handler;
 };
 
+static char *siano_msgs[] = {
+	[MSG_TYPE_BASE_VAL                           - MSG_TYPE_BASE_VAL] = "MSG_TYPE_BASE_VAL",
+	[MSG_SMS_GET_VERSION_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_VERSION_REQ",
+	[MSG_SMS_GET_VERSION_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_VERSION_RES",
+	[MSG_SMS_MULTI_BRIDGE_CFG                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_MULTI_BRIDGE_CFG",
+	[MSG_SMS_GPIO_CONFIG_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_GPIO_CONFIG_REQ",
+	[MSG_SMS_GPIO_CONFIG_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_GPIO_CONFIG_RES",
+	[MSG_SMS_GPIO_SET_LEVEL_REQ                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_GPIO_SET_LEVEL_REQ",
+	[MSG_SMS_GPIO_SET_LEVEL_RES                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_GPIO_SET_LEVEL_RES",
+	[MSG_SMS_GPIO_GET_LEVEL_REQ                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_GPIO_GET_LEVEL_REQ",
+	[MSG_SMS_GPIO_GET_LEVEL_RES                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_GPIO_GET_LEVEL_RES",
+	[MSG_SMS_EEPROM_BURN_IND                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_EEPROM_BURN_IND",
+	[MSG_SMS_LOG_ENABLE_CHANGE_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_LOG_ENABLE_CHANGE_REQ",
+	[MSG_SMS_LOG_ENABLE_CHANGE_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_LOG_ENABLE_CHANGE_RES",
+	[MSG_SMS_SET_MAX_TX_MSG_LEN_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_SET_MAX_TX_MSG_LEN_REQ",
+	[MSG_SMS_SET_MAX_TX_MSG_LEN_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_SET_MAX_TX_MSG_LEN_RES",
+	[MSG_SMS_SPI_HALFDUPLEX_TOKEN_HOST_TO_DEVICE - MSG_TYPE_BASE_VAL] = "MSG_SMS_SPI_HALFDUPLEX_TOKEN_HOST_TO_DEVICE",
+	[MSG_SMS_SPI_HALFDUPLEX_TOKEN_DEVICE_TO_HOST - MSG_TYPE_BASE_VAL] = "MSG_SMS_SPI_HALFDUPLEX_TOKEN_DEVICE_TO_HOST",
+	[MSG_SMS_BACKGROUND_SCAN_FLAG_CHANGE_REQ     - MSG_TYPE_BASE_VAL] = "MSG_SMS_BACKGROUND_SCAN_FLAG_CHANGE_REQ",
+	[MSG_SMS_BACKGROUND_SCAN_FLAG_CHANGE_RES     - MSG_TYPE_BASE_VAL] = "MSG_SMS_BACKGROUND_SCAN_FLAG_CHANGE_RES",
+	[MSG_SMS_BACKGROUND_SCAN_SIGNAL_DETECTED_IND - MSG_TYPE_BASE_VAL] = "MSG_SMS_BACKGROUND_SCAN_SIGNAL_DETECTED_IND",
+	[MSG_SMS_BACKGROUND_SCAN_NO_SIGNAL_IND       - MSG_TYPE_BASE_VAL] = "MSG_SMS_BACKGROUND_SCAN_NO_SIGNAL_IND",
+	[MSG_SMS_CONFIGURE_RF_SWITCH_REQ             - MSG_TYPE_BASE_VAL] = "MSG_SMS_CONFIGURE_RF_SWITCH_REQ",
+	[MSG_SMS_CONFIGURE_RF_SWITCH_RES             - MSG_TYPE_BASE_VAL] = "MSG_SMS_CONFIGURE_RF_SWITCH_RES",
+	[MSG_SMS_MRC_PATH_DISCONNECT_REQ             - MSG_TYPE_BASE_VAL] = "MSG_SMS_MRC_PATH_DISCONNECT_REQ",
+	[MSG_SMS_MRC_PATH_DISCONNECT_RES             - MSG_TYPE_BASE_VAL] = "MSG_SMS_MRC_PATH_DISCONNECT_RES",
+	[MSG_SMS_RECEIVE_1SEG_THROUGH_FULLSEG_REQ    - MSG_TYPE_BASE_VAL] = "MSG_SMS_RECEIVE_1SEG_THROUGH_FULLSEG_REQ",
+	[MSG_SMS_RECEIVE_1SEG_THROUGH_FULLSEG_RES    - MSG_TYPE_BASE_VAL] = "MSG_SMS_RECEIVE_1SEG_THROUGH_FULLSEG_RES",
+	[MSG_SMS_RECEIVE_VHF_VIA_VHF_INPUT_REQ       - MSG_TYPE_BASE_VAL] = "MSG_SMS_RECEIVE_VHF_VIA_VHF_INPUT_REQ",
+	[MSG_SMS_RECEIVE_VHF_VIA_VHF_INPUT_RES       - MSG_TYPE_BASE_VAL] = "MSG_SMS_RECEIVE_VHF_VIA_VHF_INPUT_RES",
+	[MSG_WR_REG_RFT_REQ                          - MSG_TYPE_BASE_VAL] = "MSG_WR_REG_RFT_REQ",
+	[MSG_WR_REG_RFT_RES                          - MSG_TYPE_BASE_VAL] = "MSG_WR_REG_RFT_RES",
+	[MSG_RD_REG_RFT_REQ                          - MSG_TYPE_BASE_VAL] = "MSG_RD_REG_RFT_REQ",
+	[MSG_RD_REG_RFT_RES                          - MSG_TYPE_BASE_VAL] = "MSG_RD_REG_RFT_RES",
+	[MSG_RD_REG_ALL_RFT_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_RD_REG_ALL_RFT_REQ",
+	[MSG_RD_REG_ALL_RFT_RES                      - MSG_TYPE_BASE_VAL] = "MSG_RD_REG_ALL_RFT_RES",
+	[MSG_HELP_INT                                - MSG_TYPE_BASE_VAL] = "MSG_HELP_INT",
+	[MSG_RUN_SCRIPT_INT                          - MSG_TYPE_BASE_VAL] = "MSG_RUN_SCRIPT_INT",
+	[MSG_SMS_EWS_INBAND_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_EWS_INBAND_REQ",
+	[MSG_SMS_EWS_INBAND_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_EWS_INBAND_RES",
+	[MSG_SMS_RFS_SELECT_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_RFS_SELECT_REQ",
+	[MSG_SMS_RFS_SELECT_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_RFS_SELECT_RES",
+	[MSG_SMS_MB_GET_VER_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_MB_GET_VER_REQ",
+	[MSG_SMS_MB_GET_VER_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_MB_GET_VER_RES",
+	[MSG_SMS_MB_WRITE_CFGFILE_REQ                - MSG_TYPE_BASE_VAL] = "MSG_SMS_MB_WRITE_CFGFILE_REQ",
+	[MSG_SMS_MB_WRITE_CFGFILE_RES                - MSG_TYPE_BASE_VAL] = "MSG_SMS_MB_WRITE_CFGFILE_RES",
+	[MSG_SMS_MB_READ_CFGFILE_REQ                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_MB_READ_CFGFILE_REQ",
+	[MSG_SMS_MB_READ_CFGFILE_RES                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_MB_READ_CFGFILE_RES",
+	[MSG_SMS_RD_MEM_REQ                          - MSG_TYPE_BASE_VAL] = "MSG_SMS_RD_MEM_REQ",
+	[MSG_SMS_RD_MEM_RES                          - MSG_TYPE_BASE_VAL] = "MSG_SMS_RD_MEM_RES",
+	[MSG_SMS_WR_MEM_REQ                          - MSG_TYPE_BASE_VAL] = "MSG_SMS_WR_MEM_REQ",
+	[MSG_SMS_WR_MEM_RES                          - MSG_TYPE_BASE_VAL] = "MSG_SMS_WR_MEM_RES",
+	[MSG_SMS_UPDATE_MEM_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_UPDATE_MEM_REQ",
+	[MSG_SMS_UPDATE_MEM_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_UPDATE_MEM_RES",
+	[MSG_SMS_ISDBT_ENABLE_FULL_PARAMS_SET_REQ    - MSG_TYPE_BASE_VAL] = "MSG_SMS_ISDBT_ENABLE_FULL_PARAMS_SET_REQ",
+	[MSG_SMS_ISDBT_ENABLE_FULL_PARAMS_SET_RES    - MSG_TYPE_BASE_VAL] = "MSG_SMS_ISDBT_ENABLE_FULL_PARAMS_SET_RES",
+	[MSG_SMS_RF_TUNE_REQ                         - MSG_TYPE_BASE_VAL] = "MSG_SMS_RF_TUNE_REQ",
+	[MSG_SMS_RF_TUNE_RES                         - MSG_TYPE_BASE_VAL] = "MSG_SMS_RF_TUNE_RES",
+	[MSG_SMS_ISDBT_ENABLE_HIGH_MOBILITY_REQ      - MSG_TYPE_BASE_VAL] = "MSG_SMS_ISDBT_ENABLE_HIGH_MOBILITY_REQ",
+	[MSG_SMS_ISDBT_ENABLE_HIGH_MOBILITY_RES      - MSG_TYPE_BASE_VAL] = "MSG_SMS_ISDBT_ENABLE_HIGH_MOBILITY_RES",
+	[MSG_SMS_ISDBT_SB_RECEPTION_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_ISDBT_SB_RECEPTION_REQ",
+	[MSG_SMS_ISDBT_SB_RECEPTION_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_ISDBT_SB_RECEPTION_RES",
+	[MSG_SMS_GENERIC_EPROM_WRITE_REQ             - MSG_TYPE_BASE_VAL] = "MSG_SMS_GENERIC_EPROM_WRITE_REQ",
+	[MSG_SMS_GENERIC_EPROM_WRITE_RES             - MSG_TYPE_BASE_VAL] = "MSG_SMS_GENERIC_EPROM_WRITE_RES",
+	[MSG_SMS_GENERIC_EPROM_READ_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_GENERIC_EPROM_READ_REQ",
+	[MSG_SMS_GENERIC_EPROM_READ_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_GENERIC_EPROM_READ_RES",
+	[MSG_SMS_EEPROM_WRITE_REQ                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_EEPROM_WRITE_REQ",
+	[MSG_SMS_EEPROM_WRITE_RES                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_EEPROM_WRITE_RES",
+	[MSG_SMS_CUSTOM_READ_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_CUSTOM_READ_REQ",
+	[MSG_SMS_CUSTOM_READ_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_CUSTOM_READ_RES",
+	[MSG_SMS_CUSTOM_WRITE_REQ                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_CUSTOM_WRITE_REQ",
+	[MSG_SMS_CUSTOM_WRITE_RES                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_CUSTOM_WRITE_RES",
+	[MSG_SMS_INIT_DEVICE_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_INIT_DEVICE_REQ",
+	[MSG_SMS_INIT_DEVICE_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_INIT_DEVICE_RES",
+	[MSG_SMS_ATSC_SET_ALL_IP_REQ                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_SET_ALL_IP_REQ",
+	[MSG_SMS_ATSC_SET_ALL_IP_RES                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_SET_ALL_IP_RES",
+	[MSG_SMS_ATSC_START_ENSEMBLE_REQ             - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_START_ENSEMBLE_REQ",
+	[MSG_SMS_ATSC_START_ENSEMBLE_RES             - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_START_ENSEMBLE_RES",
+	[MSG_SMS_SET_OUTPUT_MODE_REQ                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_SET_OUTPUT_MODE_REQ",
+	[MSG_SMS_SET_OUTPUT_MODE_RES                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_SET_OUTPUT_MODE_RES",
+	[MSG_SMS_ATSC_IP_FILTER_GET_LIST_REQ         - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_IP_FILTER_GET_LIST_REQ",
+	[MSG_SMS_ATSC_IP_FILTER_GET_LIST_RES         - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_IP_FILTER_GET_LIST_RES",
+	[MSG_SMS_SUB_CHANNEL_START_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_SUB_CHANNEL_START_REQ",
+	[MSG_SMS_SUB_CHANNEL_START_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_SUB_CHANNEL_START_RES",
+	[MSG_SMS_SUB_CHANNEL_STOP_REQ                - MSG_TYPE_BASE_VAL] = "MSG_SMS_SUB_CHANNEL_STOP_REQ",
+	[MSG_SMS_SUB_CHANNEL_STOP_RES                - MSG_TYPE_BASE_VAL] = "MSG_SMS_SUB_CHANNEL_STOP_RES",
+	[MSG_SMS_ATSC_IP_FILTER_ADD_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_IP_FILTER_ADD_REQ",
+	[MSG_SMS_ATSC_IP_FILTER_ADD_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_IP_FILTER_ADD_RES",
+	[MSG_SMS_ATSC_IP_FILTER_REMOVE_REQ           - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_IP_FILTER_REMOVE_REQ",
+	[MSG_SMS_ATSC_IP_FILTER_REMOVE_RES           - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_IP_FILTER_REMOVE_RES",
+	[MSG_SMS_ATSC_IP_FILTER_REMOVE_ALL_REQ       - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_IP_FILTER_REMOVE_ALL_REQ",
+	[MSG_SMS_ATSC_IP_FILTER_REMOVE_ALL_RES       - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_IP_FILTER_REMOVE_ALL_RES",
+	[MSG_SMS_WAIT_CMD                            - MSG_TYPE_BASE_VAL] = "MSG_SMS_WAIT_CMD",
+	[MSG_SMS_ADD_PID_FILTER_REQ                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_ADD_PID_FILTER_REQ",
+	[MSG_SMS_ADD_PID_FILTER_RES                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_ADD_PID_FILTER_RES",
+	[MSG_SMS_REMOVE_PID_FILTER_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_REMOVE_PID_FILTER_REQ",
+	[MSG_SMS_REMOVE_PID_FILTER_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_REMOVE_PID_FILTER_RES",
+	[MSG_SMS_FAST_INFORMATION_CHANNEL_REQ        - MSG_TYPE_BASE_VAL] = "MSG_SMS_FAST_INFORMATION_CHANNEL_REQ",
+	[MSG_SMS_FAST_INFORMATION_CHANNEL_RES        - MSG_TYPE_BASE_VAL] = "MSG_SMS_FAST_INFORMATION_CHANNEL_RES",
+	[MSG_SMS_DAB_CHANNEL                         - MSG_TYPE_BASE_VAL] = "MSG_SMS_DAB_CHANNEL",
+	[MSG_SMS_GET_PID_FILTER_LIST_REQ             - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_PID_FILTER_LIST_REQ",
+	[MSG_SMS_GET_PID_FILTER_LIST_RES             - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_PID_FILTER_LIST_RES",
+	[MSG_SMS_POWER_DOWN_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_POWER_DOWN_REQ",
+	[MSG_SMS_POWER_DOWN_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_POWER_DOWN_RES",
+	[MSG_SMS_ATSC_SLT_EXIST_IND                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_SLT_EXIST_IND",
+	[MSG_SMS_ATSC_NO_SLT_IND                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_ATSC_NO_SLT_IND",
+	[MSG_SMS_GET_STATISTICS_REQ                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_STATISTICS_REQ",
+	[MSG_SMS_GET_STATISTICS_RES                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_STATISTICS_RES",
+	[MSG_SMS_SEND_DUMP                           - MSG_TYPE_BASE_VAL] = "MSG_SMS_SEND_DUMP",
+	[MSG_SMS_SCAN_START_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_SCAN_START_REQ",
+	[MSG_SMS_SCAN_START_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_SCAN_START_RES",
+	[MSG_SMS_SCAN_STOP_REQ                       - MSG_TYPE_BASE_VAL] = "MSG_SMS_SCAN_STOP_REQ",
+	[MSG_SMS_SCAN_STOP_RES                       - MSG_TYPE_BASE_VAL] = "MSG_SMS_SCAN_STOP_RES",
+	[MSG_SMS_SCAN_PROGRESS_IND                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_SCAN_PROGRESS_IND",
+	[MSG_SMS_SCAN_COMPLETE_IND                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_SCAN_COMPLETE_IND",
+	[MSG_SMS_LOG_ITEM                            - MSG_TYPE_BASE_VAL] = "MSG_SMS_LOG_ITEM",
+	[MSG_SMS_DAB_SUBCHANNEL_RECONFIG_REQ         - MSG_TYPE_BASE_VAL] = "MSG_SMS_DAB_SUBCHANNEL_RECONFIG_REQ",
+	[MSG_SMS_DAB_SUBCHANNEL_RECONFIG_RES         - MSG_TYPE_BASE_VAL] = "MSG_SMS_DAB_SUBCHANNEL_RECONFIG_RES",
+	[MSG_SMS_HO_PER_SLICES_IND                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_HO_PER_SLICES_IND",
+	[MSG_SMS_HO_INBAND_POWER_IND                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_HO_INBAND_POWER_IND",
+	[MSG_SMS_MANUAL_DEMOD_REQ                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_MANUAL_DEMOD_REQ",
+	[MSG_SMS_HO_TUNE_ON_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_HO_TUNE_ON_REQ",
+	[MSG_SMS_HO_TUNE_ON_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_HO_TUNE_ON_RES",
+	[MSG_SMS_HO_TUNE_OFF_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_HO_TUNE_OFF_REQ",
+	[MSG_SMS_HO_TUNE_OFF_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_HO_TUNE_OFF_RES",
+	[MSG_SMS_HO_PEEK_FREQ_REQ                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_HO_PEEK_FREQ_REQ",
+	[MSG_SMS_HO_PEEK_FREQ_RES                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_HO_PEEK_FREQ_RES",
+	[MSG_SMS_HO_PEEK_FREQ_IND                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_HO_PEEK_FREQ_IND",
+	[MSG_SMS_MB_ATTEN_SET_REQ                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_MB_ATTEN_SET_REQ",
+	[MSG_SMS_MB_ATTEN_SET_RES                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_MB_ATTEN_SET_RES",
+	[MSG_SMS_ENABLE_STAT_IN_I2C_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_ENABLE_STAT_IN_I2C_REQ",
+	[MSG_SMS_ENABLE_STAT_IN_I2C_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_ENABLE_STAT_IN_I2C_RES",
+	[MSG_SMS_SET_ANTENNA_CONFIG_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_SET_ANTENNA_CONFIG_REQ",
+	[MSG_SMS_SET_ANTENNA_CONFIG_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_SET_ANTENNA_CONFIG_RES",
+	[MSG_SMS_GET_STATISTICS_EX_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_STATISTICS_EX_REQ",
+	[MSG_SMS_GET_STATISTICS_EX_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_STATISTICS_EX_RES",
+	[MSG_SMS_SLEEP_RESUME_COMP_IND               - MSG_TYPE_BASE_VAL] = "MSG_SMS_SLEEP_RESUME_COMP_IND",
+	[MSG_SMS_SWITCH_HOST_INTERFACE_REQ           - MSG_TYPE_BASE_VAL] = "MSG_SMS_SWITCH_HOST_INTERFACE_REQ",
+	[MSG_SMS_SWITCH_HOST_INTERFACE_RES           - MSG_TYPE_BASE_VAL] = "MSG_SMS_SWITCH_HOST_INTERFACE_RES",
+	[MSG_SMS_DATA_DOWNLOAD_REQ                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_DATA_DOWNLOAD_REQ",
+	[MSG_SMS_DATA_DOWNLOAD_RES                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_DATA_DOWNLOAD_RES",
+	[MSG_SMS_DATA_VALIDITY_REQ                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_DATA_VALIDITY_REQ",
+	[MSG_SMS_DATA_VALIDITY_RES                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_DATA_VALIDITY_RES",
+	[MSG_SMS_SWDOWNLOAD_TRIGGER_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_SWDOWNLOAD_TRIGGER_REQ",
+	[MSG_SMS_SWDOWNLOAD_TRIGGER_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_SWDOWNLOAD_TRIGGER_RES",
+	[MSG_SMS_SWDOWNLOAD_BACKDOOR_REQ             - MSG_TYPE_BASE_VAL] = "MSG_SMS_SWDOWNLOAD_BACKDOOR_REQ",
+	[MSG_SMS_SWDOWNLOAD_BACKDOOR_RES             - MSG_TYPE_BASE_VAL] = "MSG_SMS_SWDOWNLOAD_BACKDOOR_RES",
+	[MSG_SMS_GET_VERSION_EX_REQ                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_VERSION_EX_REQ",
+	[MSG_SMS_GET_VERSION_EX_RES                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_VERSION_EX_RES",
+	[MSG_SMS_CLOCK_OUTPUT_CONFIG_REQ             - MSG_TYPE_BASE_VAL] = "MSG_SMS_CLOCK_OUTPUT_CONFIG_REQ",
+	[MSG_SMS_CLOCK_OUTPUT_CONFIG_RES             - MSG_TYPE_BASE_VAL] = "MSG_SMS_CLOCK_OUTPUT_CONFIG_RES",
+	[MSG_SMS_I2C_SET_FREQ_REQ                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_I2C_SET_FREQ_REQ",
+	[MSG_SMS_I2C_SET_FREQ_RES                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_I2C_SET_FREQ_RES",
+	[MSG_SMS_GENERIC_I2C_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_GENERIC_I2C_REQ",
+	[MSG_SMS_GENERIC_I2C_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_GENERIC_I2C_RES",
+	[MSG_SMS_DVBT_BDA_DATA                       - MSG_TYPE_BASE_VAL] = "MSG_SMS_DVBT_BDA_DATA",
+	[MSG_SW_RELOAD_REQ                           - MSG_TYPE_BASE_VAL] = "MSG_SW_RELOAD_REQ",
+	[MSG_SMS_DATA_MSG                            - MSG_TYPE_BASE_VAL] = "MSG_SMS_DATA_MSG",
+	[MSG_TABLE_UPLOAD_REQ                        - MSG_TYPE_BASE_VAL] = "MSG_TABLE_UPLOAD_REQ",
+	[MSG_TABLE_UPLOAD_RES                        - MSG_TYPE_BASE_VAL] = "MSG_TABLE_UPLOAD_RES",
+	[MSG_SW_RELOAD_START_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SW_RELOAD_START_REQ",
+	[MSG_SW_RELOAD_START_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SW_RELOAD_START_RES",
+	[MSG_SW_RELOAD_EXEC_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SW_RELOAD_EXEC_REQ",
+	[MSG_SW_RELOAD_EXEC_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SW_RELOAD_EXEC_RES",
+	[MSG_SMS_SPI_INT_LINE_SET_REQ                - MSG_TYPE_BASE_VAL] = "MSG_SMS_SPI_INT_LINE_SET_REQ",
+	[MSG_SMS_SPI_INT_LINE_SET_RES                - MSG_TYPE_BASE_VAL] = "MSG_SMS_SPI_INT_LINE_SET_RES",
+	[MSG_SMS_GPIO_CONFIG_EX_REQ                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_GPIO_CONFIG_EX_REQ",
+	[MSG_SMS_GPIO_CONFIG_EX_RES                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_GPIO_CONFIG_EX_RES",
+	[MSG_SMS_WATCHDOG_ACT_REQ                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_WATCHDOG_ACT_REQ",
+	[MSG_SMS_WATCHDOG_ACT_RES                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_WATCHDOG_ACT_RES",
+	[MSG_SMS_LOOPBACK_REQ                        - MSG_TYPE_BASE_VAL] = "MSG_SMS_LOOPBACK_REQ",
+	[MSG_SMS_LOOPBACK_RES                        - MSG_TYPE_BASE_VAL] = "MSG_SMS_LOOPBACK_RES",
+	[MSG_SMS_RAW_CAPTURE_START_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_RAW_CAPTURE_START_REQ",
+	[MSG_SMS_RAW_CAPTURE_START_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_RAW_CAPTURE_START_RES",
+	[MSG_SMS_RAW_CAPTURE_ABORT_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_RAW_CAPTURE_ABORT_REQ",
+	[MSG_SMS_RAW_CAPTURE_ABORT_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_RAW_CAPTURE_ABORT_RES",
+	[MSG_SMS_RAW_CAPTURE_COMPLETE_IND            - MSG_TYPE_BASE_VAL] = "MSG_SMS_RAW_CAPTURE_COMPLETE_IND",
+	[MSG_SMS_DATA_PUMP_IND                       - MSG_TYPE_BASE_VAL] = "MSG_SMS_DATA_PUMP_IND",
+	[MSG_SMS_DATA_PUMP_REQ                       - MSG_TYPE_BASE_VAL] = "MSG_SMS_DATA_PUMP_REQ",
+	[MSG_SMS_DATA_PUMP_RES                       - MSG_TYPE_BASE_VAL] = "MSG_SMS_DATA_PUMP_RES",
+	[MSG_SMS_FLASH_DL_REQ                        - MSG_TYPE_BASE_VAL] = "MSG_SMS_FLASH_DL_REQ",
+	[MSG_SMS_EXEC_TEST_1_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_EXEC_TEST_1_REQ",
+	[MSG_SMS_EXEC_TEST_1_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_EXEC_TEST_1_RES",
+	[MSG_SMS_ENBALE_TS_INTERFACE_REQ             - MSG_TYPE_BASE_VAL] = "MSG_SMS_ENBALE_TS_INTERFACE_REQ",
+	[MSG_SMS_ENBALE_TS_INTERFACE_RES             - MSG_TYPE_BASE_VAL] = "MSG_SMS_ENBALE_TS_INTERFACE_RES",
+	[MSG_SMS_SPI_SET_BUS_WIDTH_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_SPI_SET_BUS_WIDTH_REQ",
+	[MSG_SMS_SPI_SET_BUS_WIDTH_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_SPI_SET_BUS_WIDTH_RES",
+	[MSG_SMS_SEND_EMM_REQ                        - MSG_TYPE_BASE_VAL] = "MSG_SMS_SEND_EMM_REQ",
+	[MSG_SMS_SEND_EMM_RES                        - MSG_TYPE_BASE_VAL] = "MSG_SMS_SEND_EMM_RES",
+	[MSG_SMS_DISABLE_TS_INTERFACE_REQ            - MSG_TYPE_BASE_VAL] = "MSG_SMS_DISABLE_TS_INTERFACE_REQ",
+	[MSG_SMS_DISABLE_TS_INTERFACE_RES            - MSG_TYPE_BASE_VAL] = "MSG_SMS_DISABLE_TS_INTERFACE_RES",
+	[MSG_SMS_IS_BUF_FREE_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_IS_BUF_FREE_REQ",
+	[MSG_SMS_IS_BUF_FREE_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_IS_BUF_FREE_RES",
+	[MSG_SMS_EXT_ANTENNA_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_EXT_ANTENNA_REQ",
+	[MSG_SMS_EXT_ANTENNA_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_EXT_ANTENNA_RES",
+	[MSG_SMS_CMMB_GET_NET_OF_FREQ_REQ_OBSOLETE   - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_GET_NET_OF_FREQ_REQ_OBSOLETE",
+	[MSG_SMS_CMMB_GET_NET_OF_FREQ_RES_OBSOLETE   - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_GET_NET_OF_FREQ_RES_OBSOLETE",
+	[MSG_SMS_BATTERY_LEVEL_REQ                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_BATTERY_LEVEL_REQ",
+	[MSG_SMS_BATTERY_LEVEL_RES                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_BATTERY_LEVEL_RES",
+	[MSG_SMS_CMMB_INJECT_TABLE_REQ_OBSOLETE      - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_INJECT_TABLE_REQ_OBSOLETE",
+	[MSG_SMS_CMMB_INJECT_TABLE_RES_OBSOLETE      - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_INJECT_TABLE_RES_OBSOLETE",
+	[MSG_SMS_FM_RADIO_BLOCK_IND                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_FM_RADIO_BLOCK_IND",
+	[MSG_SMS_HOST_NOTIFICATION_IND               - MSG_TYPE_BASE_VAL] = "MSG_SMS_HOST_NOTIFICATION_IND",
+	[MSG_SMS_CMMB_GET_CONTROL_TABLE_REQ_OBSOLETE - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_GET_CONTROL_TABLE_REQ_OBSOLETE",
+	[MSG_SMS_CMMB_GET_CONTROL_TABLE_RES_OBSOLETE - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_GET_CONTROL_TABLE_RES_OBSOLETE",
+	[MSG_SMS_CMMB_GET_NETWORKS_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_GET_NETWORKS_REQ",
+	[MSG_SMS_CMMB_GET_NETWORKS_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_GET_NETWORKS_RES",
+	[MSG_SMS_CMMB_START_SERVICE_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_START_SERVICE_REQ",
+	[MSG_SMS_CMMB_START_SERVICE_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_START_SERVICE_RES",
+	[MSG_SMS_CMMB_STOP_SERVICE_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_STOP_SERVICE_REQ",
+	[MSG_SMS_CMMB_STOP_SERVICE_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_STOP_SERVICE_RES",
+	[MSG_SMS_CMMB_ADD_CHANNEL_FILTER_REQ         - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_ADD_CHANNEL_FILTER_REQ",
+	[MSG_SMS_CMMB_ADD_CHANNEL_FILTER_RES         - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_ADD_CHANNEL_FILTER_RES",
+	[MSG_SMS_CMMB_REMOVE_CHANNEL_FILTER_REQ      - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_REMOVE_CHANNEL_FILTER_REQ",
+	[MSG_SMS_CMMB_REMOVE_CHANNEL_FILTER_RES      - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_REMOVE_CHANNEL_FILTER_RES",
+	[MSG_SMS_CMMB_START_CONTROL_INFO_REQ         - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_START_CONTROL_INFO_REQ",
+	[MSG_SMS_CMMB_START_CONTROL_INFO_RES         - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_START_CONTROL_INFO_RES",
+	[MSG_SMS_CMMB_STOP_CONTROL_INFO_REQ          - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_STOP_CONTROL_INFO_REQ",
+	[MSG_SMS_CMMB_STOP_CONTROL_INFO_RES          - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_STOP_CONTROL_INFO_RES",
+	[MSG_SMS_ISDBT_TUNE_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_ISDBT_TUNE_REQ",
+	[MSG_SMS_ISDBT_TUNE_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_ISDBT_TUNE_RES",
+	[MSG_SMS_TRANSMISSION_IND                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_TRANSMISSION_IND",
+	[MSG_SMS_PID_STATISTICS_IND                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_PID_STATISTICS_IND",
+	[MSG_SMS_POWER_DOWN_IND                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_POWER_DOWN_IND",
+	[MSG_SMS_POWER_DOWN_CONF                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_POWER_DOWN_CONF",
+	[MSG_SMS_POWER_UP_IND                        - MSG_TYPE_BASE_VAL] = "MSG_SMS_POWER_UP_IND",
+	[MSG_SMS_POWER_UP_CONF                       - MSG_TYPE_BASE_VAL] = "MSG_SMS_POWER_UP_CONF",
+	[MSG_SMS_POWER_MODE_SET_REQ                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_POWER_MODE_SET_REQ",
+	[MSG_SMS_POWER_MODE_SET_RES                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_POWER_MODE_SET_RES",
+	[MSG_SMS_DEBUG_HOST_EVENT_REQ                - MSG_TYPE_BASE_VAL] = "MSG_SMS_DEBUG_HOST_EVENT_REQ",
+	[MSG_SMS_DEBUG_HOST_EVENT_RES                - MSG_TYPE_BASE_VAL] = "MSG_SMS_DEBUG_HOST_EVENT_RES",
+	[MSG_SMS_NEW_CRYSTAL_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_NEW_CRYSTAL_REQ",
+	[MSG_SMS_NEW_CRYSTAL_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_NEW_CRYSTAL_RES",
+	[MSG_SMS_CONFIG_SPI_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_CONFIG_SPI_REQ",
+	[MSG_SMS_CONFIG_SPI_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_CONFIG_SPI_RES",
+	[MSG_SMS_I2C_SHORT_STAT_IND                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_I2C_SHORT_STAT_IND",
+	[MSG_SMS_START_IR_REQ                        - MSG_TYPE_BASE_VAL] = "MSG_SMS_START_IR_REQ",
+	[MSG_SMS_START_IR_RES                        - MSG_TYPE_BASE_VAL] = "MSG_SMS_START_IR_RES",
+	[MSG_SMS_IR_SAMPLES_IND                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_IR_SAMPLES_IND",
+	[MSG_SMS_CMMB_CA_SERVICE_IND                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_CA_SERVICE_IND",
+	[MSG_SMS_SLAVE_DEVICE_DETECTED               - MSG_TYPE_BASE_VAL] = "MSG_SMS_SLAVE_DEVICE_DETECTED",
+	[MSG_SMS_INTERFACE_LOCK_IND                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_INTERFACE_LOCK_IND",
+	[MSG_SMS_INTERFACE_UNLOCK_IND                - MSG_TYPE_BASE_VAL] = "MSG_SMS_INTERFACE_UNLOCK_IND",
+	[MSG_SMS_SEND_ROSUM_BUFF_REQ                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_SEND_ROSUM_BUFF_REQ",
+	[MSG_SMS_SEND_ROSUM_BUFF_RES                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_SEND_ROSUM_BUFF_RES",
+	[MSG_SMS_ROSUM_BUFF                          - MSG_TYPE_BASE_VAL] = "MSG_SMS_ROSUM_BUFF",
+	[MSG_SMS_SET_AES128_KEY_REQ                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_SET_AES128_KEY_REQ",
+	[MSG_SMS_SET_AES128_KEY_RES                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_SET_AES128_KEY_RES",
+	[MSG_SMS_MBBMS_WRITE_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_MBBMS_WRITE_REQ",
+	[MSG_SMS_MBBMS_WRITE_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_MBBMS_WRITE_RES",
+	[MSG_SMS_MBBMS_READ_IND                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_MBBMS_READ_IND",
+	[MSG_SMS_IQ_STREAM_START_REQ                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_IQ_STREAM_START_REQ",
+	[MSG_SMS_IQ_STREAM_START_RES                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_IQ_STREAM_START_RES",
+	[MSG_SMS_IQ_STREAM_STOP_REQ                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_IQ_STREAM_STOP_REQ",
+	[MSG_SMS_IQ_STREAM_STOP_RES                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_IQ_STREAM_STOP_RES",
+	[MSG_SMS_IQ_STREAM_DATA_BLOCK                - MSG_TYPE_BASE_VAL] = "MSG_SMS_IQ_STREAM_DATA_BLOCK",
+	[MSG_SMS_GET_EEPROM_VERSION_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_EEPROM_VERSION_REQ",
+	[MSG_SMS_GET_EEPROM_VERSION_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_GET_EEPROM_VERSION_RES",
+	[MSG_SMS_SIGNAL_DETECTED_IND                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_SIGNAL_DETECTED_IND",
+	[MSG_SMS_NO_SIGNAL_IND                       - MSG_TYPE_BASE_VAL] = "MSG_SMS_NO_SIGNAL_IND",
+	[MSG_SMS_MRC_SHUTDOWN_SLAVE_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_MRC_SHUTDOWN_SLAVE_REQ",
+	[MSG_SMS_MRC_SHUTDOWN_SLAVE_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_MRC_SHUTDOWN_SLAVE_RES",
+	[MSG_SMS_MRC_BRINGUP_SLAVE_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_MRC_BRINGUP_SLAVE_REQ",
+	[MSG_SMS_MRC_BRINGUP_SLAVE_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_MRC_BRINGUP_SLAVE_RES",
+	[MSG_SMS_EXTERNAL_LNA_CTRL_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_EXTERNAL_LNA_CTRL_REQ",
+	[MSG_SMS_EXTERNAL_LNA_CTRL_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_EXTERNAL_LNA_CTRL_RES",
+	[MSG_SMS_SET_PERIODIC_STATISTICS_REQ         - MSG_TYPE_BASE_VAL] = "MSG_SMS_SET_PERIODIC_STATISTICS_REQ",
+	[MSG_SMS_SET_PERIODIC_STATISTICS_RES         - MSG_TYPE_BASE_VAL] = "MSG_SMS_SET_PERIODIC_STATISTICS_RES",
+	[MSG_SMS_CMMB_SET_AUTO_OUTPUT_TS0_REQ        - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_SET_AUTO_OUTPUT_TS0_REQ",
+	[MSG_SMS_CMMB_SET_AUTO_OUTPUT_TS0_RES        - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_SET_AUTO_OUTPUT_TS0_RES",
+	[LOCAL_TUNE                                  - MSG_TYPE_BASE_VAL] = "LOCAL_TUNE",
+	[LOCAL_IFFT_H_ICI                            - MSG_TYPE_BASE_VAL] = "LOCAL_IFFT_H_ICI",
+	[MSG_RESYNC_REQ                              - MSG_TYPE_BASE_VAL] = "MSG_RESYNC_REQ",
+	[MSG_SMS_CMMB_GET_MRC_STATISTICS_REQ         - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_GET_MRC_STATISTICS_REQ",
+	[MSG_SMS_CMMB_GET_MRC_STATISTICS_RES         - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_GET_MRC_STATISTICS_RES",
+	[MSG_SMS_LOG_EX_ITEM                         - MSG_TYPE_BASE_VAL] = "MSG_SMS_LOG_EX_ITEM",
+	[MSG_SMS_DEVICE_DATA_LOSS_IND                - MSG_TYPE_BASE_VAL] = "MSG_SMS_DEVICE_DATA_LOSS_IND",
+	[MSG_SMS_MRC_WATCHDOG_TRIGGERED_IND          - MSG_TYPE_BASE_VAL] = "MSG_SMS_MRC_WATCHDOG_TRIGGERED_IND",
+	[MSG_SMS_USER_MSG_REQ                        - MSG_TYPE_BASE_VAL] = "MSG_SMS_USER_MSG_REQ",
+	[MSG_SMS_USER_MSG_RES                        - MSG_TYPE_BASE_VAL] = "MSG_SMS_USER_MSG_RES",
+	[MSG_SMS_SMART_CARD_INIT_REQ                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_SMART_CARD_INIT_REQ",
+	[MSG_SMS_SMART_CARD_INIT_RES                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_SMART_CARD_INIT_RES",
+	[MSG_SMS_SMART_CARD_WRITE_REQ                - MSG_TYPE_BASE_VAL] = "MSG_SMS_SMART_CARD_WRITE_REQ",
+	[MSG_SMS_SMART_CARD_WRITE_RES                - MSG_TYPE_BASE_VAL] = "MSG_SMS_SMART_CARD_WRITE_RES",
+	[MSG_SMS_SMART_CARD_READ_IND                 - MSG_TYPE_BASE_VAL] = "MSG_SMS_SMART_CARD_READ_IND",
+	[MSG_SMS_TSE_ENABLE_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_TSE_ENABLE_REQ",
+	[MSG_SMS_TSE_ENABLE_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_TSE_ENABLE_RES",
+	[MSG_SMS_CMMB_GET_SHORT_STATISTICS_REQ       - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_GET_SHORT_STATISTICS_REQ",
+	[MSG_SMS_CMMB_GET_SHORT_STATISTICS_RES       - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_GET_SHORT_STATISTICS_RES",
+	[MSG_SMS_LED_CONFIG_REQ                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_LED_CONFIG_REQ",
+	[MSG_SMS_LED_CONFIG_RES                      - MSG_TYPE_BASE_VAL] = "MSG_SMS_LED_CONFIG_RES",
+	[MSG_PWM_ANTENNA_REQ                         - MSG_TYPE_BASE_VAL] = "MSG_PWM_ANTENNA_REQ",
+	[MSG_PWM_ANTENNA_RES                         - MSG_TYPE_BASE_VAL] = "MSG_PWM_ANTENNA_RES",
+	[MSG_SMS_CMMB_SMD_SN_REQ                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_SMD_SN_REQ",
+	[MSG_SMS_CMMB_SMD_SN_RES                     - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_SMD_SN_RES",
+	[MSG_SMS_CMMB_SET_CA_CW_REQ                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_SET_CA_CW_REQ",
+	[MSG_SMS_CMMB_SET_CA_CW_RES                  - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_SET_CA_CW_RES",
+	[MSG_SMS_CMMB_SET_CA_SALT_REQ                - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_SET_CA_SALT_REQ",
+	[MSG_SMS_CMMB_SET_CA_SALT_RES                - MSG_TYPE_BASE_VAL] = "MSG_SMS_CMMB_SET_CA_SALT_RES",
+	[MSG_SMS_NSCD_INIT_REQ                       - MSG_TYPE_BASE_VAL] = "MSG_SMS_NSCD_INIT_REQ",
+	[MSG_SMS_NSCD_INIT_RES                       - MSG_TYPE_BASE_VAL] = "MSG_SMS_NSCD_INIT_RES",
+	[MSG_SMS_NSCD_PROCESS_SECTION_REQ            - MSG_TYPE_BASE_VAL] = "MSG_SMS_NSCD_PROCESS_SECTION_REQ",
+	[MSG_SMS_NSCD_PROCESS_SECTION_RES            - MSG_TYPE_BASE_VAL] = "MSG_SMS_NSCD_PROCESS_SECTION_RES",
+	[MSG_SMS_DBD_CREATE_OBJECT_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_CREATE_OBJECT_REQ",
+	[MSG_SMS_DBD_CREATE_OBJECT_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_CREATE_OBJECT_RES",
+	[MSG_SMS_DBD_CONFIGURE_REQ                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_CONFIGURE_REQ",
+	[MSG_SMS_DBD_CONFIGURE_RES                   - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_CONFIGURE_RES",
+	[MSG_SMS_DBD_SET_KEYS_REQ                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_SET_KEYS_REQ",
+	[MSG_SMS_DBD_SET_KEYS_RES                    - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_SET_KEYS_RES",
+	[MSG_SMS_DBD_PROCESS_HEADER_REQ              - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_PROCESS_HEADER_REQ",
+	[MSG_SMS_DBD_PROCESS_HEADER_RES              - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_PROCESS_HEADER_RES",
+	[MSG_SMS_DBD_PROCESS_DATA_REQ                - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_PROCESS_DATA_REQ",
+	[MSG_SMS_DBD_PROCESS_DATA_RES                - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_PROCESS_DATA_RES",
+	[MSG_SMS_DBD_PROCESS_GET_DATA_REQ            - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_PROCESS_GET_DATA_REQ",
+	[MSG_SMS_DBD_PROCESS_GET_DATA_RES            - MSG_TYPE_BASE_VAL] = "MSG_SMS_DBD_PROCESS_GET_DATA_RES",
+	[MSG_SMS_NSCD_OPEN_SESSION_REQ               - MSG_TYPE_BASE_VAL] = "MSG_SMS_NSCD_OPEN_SESSION_REQ",
+	[MSG_SMS_NSCD_OPEN_SESSION_RES               - MSG_TYPE_BASE_VAL] = "MSG_SMS_NSCD_OPEN_SESSION_RES",
+	[MSG_SMS_SEND_HOST_DATA_TO_DEMUX_REQ         - MSG_TYPE_BASE_VAL] = "MSG_SMS_SEND_HOST_DATA_TO_DEMUX_REQ",
+	[MSG_SMS_SEND_HOST_DATA_TO_DEMUX_RES         - MSG_TYPE_BASE_VAL] = "MSG_SMS_SEND_HOST_DATA_TO_DEMUX_RES",
+	[MSG_LAST_MSG_TYPE                           - MSG_TYPE_BASE_VAL] = "MSG_LAST_MSG_TYPE",
+};
+
+char *smscore_translate_msg(enum msg_types msgtype)
+{
+	int i = msgtype - MSG_TYPE_BASE_VAL;
+	char *msg;
+
+	if (i < 0 || i > ARRAY_SIZE(siano_msgs))
+		return "Unknown msg type";
+
+	msg = siano_msgs[i];
+
+	if (!*msg)
+		return "Unknown msg type";
+
+	return msg;
+}
+EXPORT_SYMBOL_GPL(smscore_translate_msg);
+
 void smscore_set_board_id(struct smscore_device_t *core, int id)
 {
 	core->board_id = id;
@@ -1013,8 +1352,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 		{
 			struct SmsVersionRes_ST *ver =
 				(struct SmsVersionRes_ST *) phdr;
-			sms_debug("MSG_SMS_GET_VERSION_EX_RES "
-				  "id %d prots 0x%x ver %d.%d",
+			sms_debug("Firmware id %d prots 0x%x ver %d.%d",
 				  ver->FirmwareId, ver->SupportedProtocols,
 				  ver->RomVersionMajor, ver->RomVersionMinor);
 
@@ -1026,39 +1364,33 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 			break;
 		}
 		case MSG_SMS_INIT_DEVICE_RES:
-			sms_debug("MSG_SMS_INIT_DEVICE_RES");
 			complete(&coredev->init_device_done);
 			break;
 		case MSG_SW_RELOAD_START_RES:
-			sms_debug("MSG_SW_RELOAD_START_RES");
 			complete(&coredev->reload_start_done);
 			break;
 		case MSG_SMS_DATA_DOWNLOAD_RES:
 			complete(&coredev->data_download_done);
 			break;
 		case MSG_SW_RELOAD_EXEC_RES:
-			sms_debug("MSG_SW_RELOAD_EXEC_RES");
 			break;
 		case MSG_SMS_SWDOWNLOAD_TRIGGER_RES:
-			sms_debug("MSG_SMS_SWDOWNLOAD_TRIGGER_RES");
 			complete(&coredev->trigger_done);
 			break;
 		case MSG_SMS_SLEEP_RESUME_COMP_IND:
 			complete(&coredev->resume_done);
 			break;
 		case MSG_SMS_GPIO_CONFIG_EX_RES:
-			sms_debug("MSG_SMS_GPIO_CONFIG_EX_RES");
 			complete(&coredev->gpio_configuration_done);
 			break;
 		case MSG_SMS_GPIO_SET_LEVEL_RES:
-			sms_debug("MSG_SMS_GPIO_SET_LEVEL_RES");
 			complete(&coredev->gpio_set_level_done);
 			break;
 		case MSG_SMS_GPIO_GET_LEVEL_RES:
 		{
 			u32 *msgdata = (u32 *) phdr;
 			coredev->gpio_get_res = msgdata[1];
-			sms_debug("MSG_SMS_GPIO_GET_LEVEL_RES gpio level %d",
+			sms_debug("gpio level %d",
 					coredev->gpio_get_res);
 			complete(&coredev->gpio_get_level_done);
 			break;
@@ -1076,6 +1408,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 			break;
 
 		default:
+			sms_debug("message not handled.\n");
 			break;
 		}
 		smscore_putbuffer(coredev, cb);
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 4a0a763..0078fef 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -937,6 +937,8 @@ struct smscore_config_gpio {
 	u8 outputdriving;
 };
 
+char *smscore_translate_msg(enum msg_types msgtype);
+
 extern void smscore_registry_setmode(char *devpath, int mode);
 extern int smscore_registry_getmode(char *devpath);
 
diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index aa77e54..57f3560 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -249,20 +249,16 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 		break;
 
 	case MSG_SMS_SIGNAL_DETECTED_IND:
-		sms_info("MSG_SMS_SIGNAL_DETECTED_IND");
 		client->sms_stat_dvb.TransmissionData.IsDemodLocked = true;
 		is_status_update = true;
 		break;
 
 	case MSG_SMS_NO_SIGNAL_IND:
-		sms_info("MSG_SMS_NO_SIGNAL_IND");
 		client->sms_stat_dvb.TransmissionData.IsDemodLocked = false;
 		is_status_update = true;
 		break;
 
 	case MSG_SMS_TRANSMISSION_IND: {
-		sms_info("MSG_SMS_TRANSMISSION_IND");
-
 		pMsgData++;
 		memcpy(&client->sms_stat_dvb.TransmissionData, pMsgData,
 				sizeof(struct TRANSMISSION_STATISTICS_S));
@@ -281,7 +277,6 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 				&client->sms_stat_dvb.ReceptionData;
 		struct SRVM_SIGNAL_STATUS_S SignalStatusData;
 
-		/*sms_info("MSG_SMS_HO_PER_SLICES_IND");*/
 		pMsgData++;
 		SignalStatusData.result = pMsgData[0];
 		SignalStatusData.snr = pMsgData[1];
@@ -336,8 +331,6 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 		struct RECEPTION_STATISTICS_S *pReceptionData =
 				&client->sms_stat_dvb.ReceptionData;
 
-		sms_info("MSG_SMS_GET_STATISTICS_RES");
-
 		is_status_update = true;
 
 		switch (smscore_get_device_mode(client->coredev)) {
@@ -360,8 +353,7 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 		break;
 	}
 	default:
-		sms_info("Unhandled message %d", phdr->msgType);
-
+		sms_info("message not handled");
 	}
 	smscore_putbuffer(client->coredev, cb);
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index de2c102..2050e4c 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -106,6 +106,10 @@ static void smsusb_onresponse(struct urb *urb)
 			} else
 				surb->cb->offset = 0;
 
+			sms_debug("received %s(%d) size: %d",
+				  smscore_translate_msg(phdr->msgType),
+				  phdr->msgType, phdr->msgLength);
+
 			smscore_onresponse(dev->coredev, surb->cb);
 			surb->cb = NULL;
 		} else {
@@ -181,8 +185,13 @@ static int smsusb_start_streaming(struct smsusb_device_t *dev)
 static int smsusb_sendrequest(void *context, void *buffer, size_t size)
 {
 	struct smsusb_device_t *dev = (struct smsusb_device_t *) context;
+	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) buffer;
 	int dummy;
 
+	sms_debug("sending %s(%d) size: %d",
+		  smscore_translate_msg(phdr->msgType), phdr->msgType,
+		  phdr->msgLength);
+
 	smsendian_handle_message_header((struct SmsMsgHdr_ST *)buffer);
 	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
 			    buffer, size, &dummy, 1000);
-- 
1.8.1.4

